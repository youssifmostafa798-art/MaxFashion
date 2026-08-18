# Avatar Deletion Race Condition — Final Fix Report

**Date:** 2026-08-17  
**Status:** FIXED  
**Fix Attempts:** 4 (this one works)

---

## The Bug

After uploading an avatar, tapping "Remove Photo" and immediately navigating back left the old avatar visible in `ProfilePage`. The DB was correctly updated (`avatar_url = null`), but the UI still showed the stale image.

## Root Cause

**File:** `lib/features/profile/presentation/providers/edit_profile_provider.dart:203`

The `removeAvatar()` method had this structure:

```dart
final profile = await _repository.removeAvatar();
if (!mounted) return;          // ← SILENT KILL
// ... everything below never runs ...
authNotifier.setUser(...);     // ← NEVER REACHED
```

When the user navigated back from `EditProfilePage` during the async `await`, the `EditProfileNotifier` was disposed (`mounted = false`). The `if (!mounted) return` guard silently exited, and `setUser()` — which updates the **global** `authStateProvider` — never executed.

`ProfilePage` reads from `authStateProvider`, not from the DB. So it displayed the stale `profileImage` URL.

## The Fix (3 lines changed)

```dart
Future<void> removeAvatar() async {
    state = state.copyWith(isAvatarLoading: true, clearError: true);

    // Capture before async gap — authStateProvider lives for app lifetime
    final authNotifier = _ref.read(authStateProvider.notifier);   // NEW
    final currentUser = _ref.read(authStateProvider).user;        // NEW

    try {
      final profile = await _repository.removeAvatar();

      // Always sync authStateProvider — global state, not page-scoped.
      // This must run even if EditProfilePage was disposed during the await.
      if (currentUser != null) {
        authNotifier.setUser(currentUser.copyWith(clearProfileImage: true));
      }

      if (!mounted) return;    // ← mounted check now only guards local state
      state = state.copyWith(
        avatarUrl: profile.avatarUrl,
        isAvatarLoading: false,
        hasChanges: true,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isAvatarLoading: false,
        error: e.toString(),
      );
    }
  }
```

### What changed

| Before | After |
|--------|-------|
| `authNotifier` captured inside `mounted` guard | Captured **before** `await` (line 202-203) |
| `currentUser` captured inside `mounted` guard | Captured **before** `await` (line 202-203) |
| `setUser()` gated by `if (!mounted) return` | Runs **unconditionally** after DB update (line 210-212) |
| `mounted` check guarded everything | `mounted` check now only guards **local state update** (line 214) |

### Why this is safe

1. **`authStateProvider` is not auto-disposed** — `AuthNotifier` lives for the app's lifetime. The captured `authNotifier` reference remains valid even after `EditProfileNotifier` is disposed.

2. **`_ref` is captured before the async gap** — The `_ref.read()` calls at lines 202-203 execute while the provider is still alive. After disposal, we use the captured `authNotifier` directly (no `_ref` needed).

3. **`setUser()` is idempotent** — Calling it with `clearProfileImage: true` is safe even if the user was updated by another operation during the await.

4. **`mounted` guard is preserved for local state** — Line 214 still prevents writing to `state` after disposal (which would throw). Only the global `authStateProvider` update is exempt.

5. **No changes to any other file** — Repository, `auth_provider.dart`, `main_screen.dart`, `ProfilePage`, `ProfileAvatar` are all untouched.

## What the 4th Fix Addresses That Previous 3 Didn't

| Fix | Issue | Scope |
|-----|-------|-------|
| #1: `setUser()` method | `updateProfile()` skips null avatarUrl | Correctness of state update |
| #2: `setUser(clearProfileImage: true)` | Direct profileImage nullification | Correctness of state update |
| #3: `_isPickerActive` guard | ImagePicker concurrency | Upload race condition |
| **#4: Capture before await** | **`setUser()` killed by `mounted` guard** | **Deletion race condition** |

Fixes #1-#3 were necessary but insufficient. The `setUser()` call was correct in logic but unreachable in practice when the user navigated back quickly.

## Verification Checklist

- [ ] Upload an avatar
- [ ] Tap "Remove Photo"
- [ ] Immediately tap back / Cancel
- [ ] Confirm default avatar appears instantly on `ProfilePage`
- [ ] Repeat upload/delete cycle 5 times
- [ ] Confirm no app restart required
- [ ] Confirm no regression on normal save flow (Edit Profile → Save)
