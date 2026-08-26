-- ============================================================
-- Restore English-Only Product Content
-- ============================================================
-- Objective: Restore original English product names and
-- descriptions to the products table, remove the
-- product_translations infrastructure, and simplify
-- search to operate directly on products.
-- ============================================================

BEGIN;

-- 1. Restore original English product content from the seed data.
--    The products table is the authoritative source; product_translations
--    becomes unnecessary after this migration.

UPDATE products SET name = 'Coastal Voyager Shades', description = 'Engineered with precision-cut polarized lenses that eliminate glare from any angle. The lightweight titanium frame sits comfortably for all-day wear, making these ideal for driving, fishing, or weekend adventures.' WHERE id = 1;
UPDATE products SET name = 'Midnight Horizon Aviators', description = 'A bold statement piece featuring gradient smoke lenses and a reinforced acetate frame. UV400 protection shields your eyes from harmful rays while the classic silhouette complements any casual outfit.' WHERE id = 2;
UPDATE products SET name = 'Polarized Trail Blazer', description = 'Hand-polished crystal lenses deliver exceptional clarity in bright conditions. The brushed metal temples feature rubber-tipped ends for a secure, non-slip fit during active outdoor pursuits.' WHERE id = 3;
UPDATE products SET name = 'Retro Wave Spectacles', description = 'Inspired by vintage aviation design, these aviators feature teardrop-shaped lenses with anti-reflective coating. The adjustable nose pads ensure a customized fit for every face shape.' WHERE id = 4;
UPDATE products SET name = 'Summit Explorer Optics', description = 'Wraparound sport design provides full peripheral coverage and wind protection. The impact-resistant polycarbonate lenses meet military-grade standards, perfect for cycling, running, or hiking.' WHERE id = 5;
UPDATE products SET name = 'Urban Nomad Glasses', description = 'Retro-inspired round frames crafted from sustainable bio-acetate. The warm gradient tint adds a touch of sophistication while providing 100% UV protection for city strolls.' WHERE id = 6;
UPDATE products SET name = 'Vanguard Field Watch', description = 'Moonphase complication tracks lunar cycles with astronomical precision. The enamel dial features hand-painted artwork inspired by celestial navigation.' WHERE id = 7;
UPDATE products SET name = 'Prestige Dress Chronograph', description = 'Diver-rated to 300 meters with unidirectional rotating bezel and luminous hands for underwater legibility. The helium escape valve protects during saturation diving.' WHERE id = 8;
UPDATE products SET name = 'Horizon Solar Powered', description = 'World time complication displays all 24 time zones on a single dial. The city indicator ring rotates with the hour hand for instant reference.' WHERE id = 9;
UPDATE products SET name = 'Eclipse Moonphase Elite', description = 'Skeleton dial reveals the intricate inner workings of the automatic movement. The exposed bridges and gears showcase traditional watchmaking artistry.' WHERE id = 10;
UPDATE products SET name = 'Frontier Expedition Watch', description = 'Field watch with high-contrast dial and luminous Arabic numerals. The NATO strap provides reliable comfort in extreme outdoor conditions.' WHERE id = 11;
UPDATE products SET name = 'Sovereign Grand Complication', description = 'Dress watch with ultra-thin 6mm case that slides effortlessly under shirt cuffs. The Milanese mesh bracelet adjusts infinitely for perfect fit.' WHERE id = 12;
UPDATE products SET name = 'Urban Commuter Jean', description = 'Relaxed fit through the seat and thigh with a gentle taper from knee to hem. The 12oz weight provides structure without stiffness.' WHERE id = 14;
UPDATE products SET name = 'Heritage selvedge raw', description = 'Japanese rope-dyed denim achieves deep indigo saturation that fades beautifully over time. The selvedge ID shows as a subtle detail when cuffed.' WHERE id = 15;
UPDATE products SET name = 'Pacific Coast Relaxed', description = 'Comfort waist with hidden elastic panels eliminates belt dependency while maintaining a tailored appearance. Ideal for transitional sizes.' WHERE id = 16;
UPDATE products SET name = 'Ember Slim Fit', description = 'Athletic taper provides extra room in the quadriceps, narrowing significantly below the knee. The stretch fabric moves with you during activity.' WHERE id = 17;
UPDATE products SET name = 'Frontier Rugged Jean', description = 'High-rise vintage cut sits at the natural waist for a retro silhouette. The button fly adds authentic heritage detail.' WHERE id = 18;
UPDATE products SET name = 'Voyager Comfort Fit', description = 'Rigid selvedge with minimal processing preserves the fabric''s natural texture. Breaking in these jeans creates deeply personal fade patterns.' WHERE id = 19;
UPDATE products SET name = 'Sentinel Durable Denim', description = 'Distressed detailing with strategically placed rips and frayed edges. The pre-worn appearance requires no break-in period.' WHERE id = 20;
UPDATE products SET name = 'Crest Mountain Jean', description = 'Slim straight cut with a mid-rise that works for most body types. The versatile dark wash transitions from day to evening effortlessly.' WHERE id = 21;
UPDATE products SET name = 'Horizon Light Wash', description = 'Relaxed through the hip and thigh with a straight leg from knee to hem. The 100% cotton construction breathes in warm weather.' WHERE id = 22;
UPDATE products SET name = 'Ranger Outdoor Jean', description = 'Stretch performance denim with moisture-wicking technology. The gusseted crotch allows full range of motion for active lifestyles.' WHERE id = 23;
UPDATE products SET name = 'Pioneer Stretch Denim', description = 'Raw indigo with a tight weave that develops sharp fade creases over time. The selvedge outseam prevents unraveling for lasting durability.' WHERE id = 24;
UPDATE products SET name = 'Legacy Traditional Fit', description = 'Vintage light wash with natural fading at stress points. The soft, broken-in feel requires no painful break-in period.' WHERE id = 25;
UPDATE products SET name = 'Pacific Wind Polo', description = 'Brushed cotton interior provides soft warmth for transitional weather. The smooth exterior maintains a polished appearance.' WHERE id = 26;
UPDATE products SET name = 'Aurora Contrast Polo', description = 'Pinstripe pattern woven into the knit adds subtle sophistication. The tonal colorway keeps the look refined and understated.' WHERE id = 27;
UPDATE products SET name = 'Catalyst Active Mesh', description = 'Lacoste-style croc-free design with clean branding. The minimalist approach lets the quality of fabric and construction speak for itself.' WHERE id = 28;
UPDATE products SET name = 'Eclipse Slim Performance', description = 'Woven label at the hem adds subtle branding detail. The bar-tacked seams withstand repeated washing and wearing.' WHERE id = 29;
UPDATE products SET name = 'Vanguard Luxury Cotton', description = 'Athletic cut with raglan sleeves for increased range of motion. The flatlock seams prevent chafing during physical activity.' WHERE id = 30;
UPDATE products SET name = 'Heritage Pique Polo', description = 'Classic pique knit construction creates the signature textured surface that defines authentic polo shirts. The two-button placket and structured collar maintain a polished appearance from the office to the golf course.' WHERE id = 31;
UPDATE products SET name = 'Performance Tech Polo', description = 'Moisture-wicking performance fabric pulls sweat away from the skin, keeping you dry during intense activity. UPF 30+ protection shields against harmful UV radiation on sunny days.' WHERE id = 32;
UPDATE products SET name = 'Linen Breeze Polo', description = 'Linen-cotton blend offers the breathability of linen with the softness of cotton. The relaxed fit drapes naturally for warm-weather comfort without looking sloppy.' WHERE id = 33;
UPDATE products SET name = 'Classic Collar Original', description = 'Heritage-inspired design with vintage-width collar and two-button placket. The pre-washed fabric eliminates shrinkage and provides immediate softness from the first wear.' WHERE id = 34;
UPDATE products SET name = 'Athletic Mesh Performance', description = 'Interlock knit creates a smooth, refined surface on both sides of the fabric. The clean finish works equally well tucked into dress pants or worn casually with chinos.' WHERE id = 35;
UPDATE products SET name = 'Luxe Silk Blend Polo', description = 'Textured jacquard knit adds visual interest with a subtle geometric pattern. The moisture-management technology keeps you comfortable in humid conditions.' WHERE id = 36;
UPDATE products SET name = 'Coastal Casual Polo', description = 'Contrast collar and cuff tipping adds a sporty accent to the classic polo silhouette. The ribbed construction maintains shape through countless washes.' WHERE id = 37;
UPDATE products SET name = 'Metropolitan Slim Polo', description = 'Stretch pique with 4% elastane provides freedom of movement without losing the structured polo appearance. The tailored fit flatters without restriction.' WHERE id = 38;
UPDATE products SET name = 'Retro Stripe Polo', description = 'Quick-dry technology accelerates evaporation after perspiration or light rain. The antimicrobial treatment prevents odor buildup during extended wear.' WHERE id = 39;
UPDATE products SET name = 'Artisan Knit Polo', description = 'Premium long-staple Egyptian cotton delivers exceptional softness that improves with each wash. The natural fiber breathes in summer and insulates in winter.' WHERE id = 40;
UPDATE products SET name = 'Nomad Travel Polo', description = 'Color-block design with contrasting panels creates a modern athletic aesthetic. The bonded seams lie flat against the skin for irritation-free comfort.' WHERE id = 41;
UPDATE products SET name = 'Linen Blend Vacation', description = 'Linen-blend fabric with a natural texture that improves with each wearing. The breathable weave makes it ideal for warm-weather occasions.' WHERE id = 42;
UPDATE products SET name = 'Flannel Check Autumn', description = 'Brushed flannel with a classic buffalo check pattern for autumn warmth. The heavyweight construction provides insulation without excessive bulk.' WHERE id = 43;
UPDATE products SET name = 'Poplin Crisp Formal', description = 'Poplin dress shirt in a solid color with a tailored fit for formal occasions. The wrinkle-resistant finish maintains a crisp appearance throughout the day.' WHERE id = 44;
UPDATE products SET name = 'Camp Collar Resort', description = 'Camp collar with a relaxed drape and short sleeves for resort wear. The lightweight fabric packs easily for vacation without excessive wrinkling.' WHERE id = 45;
UPDATE products SET name = 'Oxford Business Casual', description = 'Oxford button-down with a versatile semi-formal appearance suitable for the office or weekend brunch. The durable fabric improves with age.' WHERE id = 46;
UPDATE products SET name = 'Chambray Weekend Relaxed', description = 'Soft chambray with a lived-in feel from day one. The casual styling pairs naturally with boots or loafers for a relaxed weekend look.' WHERE id = 47;
UPDATE products SET name = 'Linen Beach Shirt', description = 'Linen-cotton blend with moisture-wicking properties for summer comfort. The natural fiber breathes in heat and insulates in cooler temperatures.' WHERE id = 48;
UPDATE products SET name = 'Flannel Forest Check', description = 'Flannel check in muted earth tones for autumn layering. The brushed interior provides warmth while the smooth exterior maintains structure.' WHERE id = 49;
UPDATE products SET name = 'Poplin Classic Fit', description = 'Poplin with a clean finish and tailoring details including darts at the back for a fitted appearance. The mitred cuffs add subtle sophistication.' WHERE id = 50;
UPDATE products SET name = 'Tropical Island Print', description = 'Tropical print with an all-over botanical pattern on lightweight cotton. The short sleeves and open collar create a breezy vacation aesthetic.' WHERE id = 51;
UPDATE products SET name = 'Corduroy Winter Warm', description = 'Corduroy in rich autumnal colors with a soft pile that catches light beautifully. The traditional button-down collar adds heritage appeal.' WHERE id = 52;
UPDATE products SET name = 'Gingham Smart Casual', description = 'Gingham in a larger check pattern for a bold, modern statement. The regular fit provides room without appearing oversized.' WHERE id = 53;
UPDATE products SET name = 'Ember Comfort Short', description = 'Comfort-oriented construction with a soft elastic waistband and no inner drawstring to cause irritation. Perfect for lounging or casual outings.' WHERE id = 54;
UPDATE products SET name = 'Pacific Breeze Short', description = 'Breeze-friendly design with mesh side panels for maximum ventilation. The lightweight construction makes it ideal for tropical climates.' WHERE id = 55;
UPDATE products SET name = 'Aurora Soft Short', description = 'Soft-touch fabric with a brushed interior for gentle comfort. The relaxed fit provides room without appearing baggy.' WHERE id = 56;
UPDATE products SET name = 'Catalyst Training Short', description = 'Training-oriented with a built-in brief for support during high-intensity workouts. The reflective details increase visibility during evening exercise.' WHERE id = 57;
UPDATE products SET name = 'Eclipse Slim Short', description = 'Slim-fit cut with a tapered leg for a modern silhouette. The stretch fabric maintains comfort despite the closer fit.' WHERE id = 58;
UPDATE products SET name = 'Vanguard Premium Short', description = 'Premium construction with attention to detail including coin pocket, reinforced belt loops, and branded hardware.' WHERE id = 59;
UPDATE products SET name = 'Premium Jersey Essential', description = 'Athletic cut with shorter sleeves and a fitted body. The performance fabric stretches during movement and recovers its shape.' WHERE id = 60;
UPDATE products SET name = 'Heritage Crew Neck Tee', description = 'Heritage-weight cotton jersey with a tight knit that holds its shape through countless washes. The crew neckline features ribbed binding that prevents stretching and maintains a clean finish.' WHERE id = 61;
UPDATE products SET name = 'Urban Street Classic', description = 'Premium Pima cotton with an ultra-fine 80s yarn count delivers buttery softness against the skin. The relaxed fit drapes naturally without clinging.' WHERE id = 62;
UPDATE products SET name = 'Relaxed Cotton Essential', description = 'Slub cotton with intentional texture variations creates visual interest in a solid-color tee. The irregular weave adds artisan character to everyday basics.' WHERE id = 63;
UPDATE products SET name = 'Modern Minimal Tee', description = 'Ribbed knit construction with 2x2 ribbing for a fitted silhouette that accentuates the physique. The stretch recovery prevents bagging at the elbows.' WHERE id = 64;
UPDATE products SET name = 'Signature Everyday Shirt', description = 'Raw edge hem creates a modern, unfinished aesthetic. The lightweight jersey drapes softly for a relaxed, effortless appearance.' WHERE id = 65;
UPDATE products SET name = 'Vintage Washed Classic', description = 'Muscle fit with wider arm openings and a shorter body length. The stretch cotton emphasizes the chest and arms while allowing full range of motion.' WHERE id = 66;
UPDATE products SET name = 'Weekend Casual Tee', description = 'Raglan sleeve construction eliminates the shoulder seam for increased mobility. The diagonal seam from collar to underarm creates a sporty aesthetic.' WHERE id = 67;
UPDATE products SET name = 'Luxe Comfort Essential', description = 'Long sleeve tee in a midweight jersey perfect for transitional weather. The streamlined fit layers comfortably under jackets and sweaters.' WHERE id = 68;
UPDATE products SET name = 'Everyday Classic Original', description = 'Henley collar with a three-button placket adds versatility to the basic tee. Wear it fully buttoned for a polished look or open for casual ease.' WHERE id = 69;
UPDATE products SET name = 'Performance Active Tee', description = 'Waffle knit with a thermal texture that traps warm air close to the skin. The textured surface adds visual depth to solid colors.' WHERE id = 70;
UPDATE products SET name = 'Breathable Mesh Tee', description = 'Color block design with contrasting panels creates a modern, graphic aesthetic. The bold color combinations make a statement without patterns.' WHERE id = 71;
UPDATE products SET name = 'Slim Fit Modern Tee', description = 'Drop shoulder construction with an oversized silhouette for streetwear styling. The heavyweight cotton holds its shape in the relaxed fit.' WHERE id = 72;
UPDATE products SET name = 'Oversized Streetwear', description = 'Pocket logo with embroidered branding on the chest pocket. The classic placement adds subtle identity without overwhelming the design.' WHERE id = 73;
UPDATE products SET name = 'Pocket Logo Heritage', description = 'Striped pattern with alternating horizontal lines for a nautical feel. The cotton-spandex blend maintains the stripe alignment wash after wash.' WHERE id = 74;
UPDATE products SET name = 'Striped Nautical Tee', description = 'V-neck with a flattering depth that elongates the neck without being too revealing. The clean finish works for casual or smart-casual settings.' WHERE id = 75;
UPDATE products SET name = 'V-Neck Contemporary', description = 'Organic cotton with GOTS certification ensures environmentally responsible production. The natural fiber feels soft against sensitive skin.' WHERE id = 76;
UPDATE products SET name = 'Henley Collar Classic', description = 'Performance dry-fit technology wicks moisture away from the body during exercise. The antimicrobial treatment prevents odor during intense workouts.' WHERE id = 77;
UPDATE products SET name = 'Waffle Knit Winter', description = 'Vintage washed finish creates a sun-faded, lived-in appearance from day one. The softened fabric requires no break-in period.' WHERE id = 78;
UPDATE products SET name = 'Raw Edge Modern', description = 'Oversized fit with extended body length for a relaxed, contemporary silhouette. The heavyweight cotton provides structure in the loose cut.' WHERE id = 79;
UPDATE products SET name = 'Muscle Fit Athletic', description = 'Minimalist solid with clean, unadorned design. The focus on fabric quality and construction creates an elevated basic essential.' WHERE id = 80;
UPDATE products SET name = 'Raglan Sport Tee', description = 'Graphic print with an artistic design that makes a statement. The water-based ink maintains softness and flexibility after printing.' WHERE id = 81;
UPDATE products SET name = 'Long Sleeve Layering', description = 'Layering base with a smooth, flat-lock seam construction. The thin profile disappears under button-downs and sweaters.' WHERE id = 82;
UPDATE products SET name = 'Color Block Urban', description = 'Breathable mesh panels under the arms increase ventilation during physical activity. The solid front maintains a casual appearance.' WHERE id = 83;
UPDATE products SET name = 'Work Steel Toe Boot', description = 'Work boot with electrical hazard protection and puncture-resistant midsole. The slip-resistant outsole meets workplace safety requirements.' WHERE id = 84;
UPDATE products SET name = 'Desert Adventure Boot', description = 'Adventure-ready with a Vibram Megagrip outsole and Gore-Tex waterproof membrane. The toe cap protects against rocks and trail debris.' WHERE id = 85;
UPDATE products SET name = 'Combat Military Boot', description = 'Military-inspired design with a high ankle collar and speed-lace hardware. The matte black finish maintains a tactical, understated appearance.' WHERE id = 86;
UPDATE products SET name = 'Hiking Mountain Boot', description = 'Insulated boot with Primaloft fill that provides warmth without bulk. The waterproof membrane keeps feet dry during winter commutes.' WHERE id = 87;
UPDATE products SET name = 'Platform Elevator Loafer', description = 'Platform loafer with a lightweight EVA sole that provides height without weight. The rubber outsole ensures traction in all conditions.' WHERE id = 88;
UPDATE products SET name = 'Leather Slip-On Classic', description = 'Leather slip-on with hand-stitched apron toe. The natural leather develops character unique to each wearer''s lifestyle.' WHERE id = 89;
UPDATE products SET name = 'Suede Penny Original', description = 'Suede penny loafer with a classic silhouette. The crepe sole provides cushioned comfort for extended periods of walking.' WHERE id = 90;
UPDATE products SET name = 'Penny Loafer Classic', description = 'Hand-stitched leather upper with a classic penny loafer silhouette. The moccasin-toe construction conforms to the foot''s natural shape for exceptional comfort from the first wear.' WHERE id = 91;
UPDATE products SET name = 'Tassel Loafer Heritage', description = 'Tassel detailing adds a preppy, Ivy League aesthetic to the traditional loafer. The leather sole with rubber heel provides traction on polished floors.' WHERE id = 92;
UPDATE products SET name = 'Bit Loafer Italian', description = 'Polished gold-tone horsebit hardware across the vamp creates an instantly recognizable luxury statement. The Italian leather upper develops a rich patina.' WHERE id = 93;
UPDATE products SET name = 'Driving Suede Loafer', description = 'Suede driving loafer with rubber pebble outsole that wraps around the heel for motorcycle-inspired functionality. The flexible construction moves with your foot.' WHERE id = 94;
UPDATE products SET name = 'Venetian Leather Original', description = 'Blake-stitched construction creates a sleek, streamlined profile. The burnished leather toe adds artisan craftsmanship to this refined slip-on.' WHERE id = 95;
UPDATE products SET name = 'Sprint Breathable Shoe', description = 'Stability guide rails prevent excessive inward pronation without intrusive posts. The plush collar and tongue provide comfortable ankle support.' WHERE id = 96;
UPDATE products SET name = 'Stability Support Runner', description = 'Trail-specific lugs dig into soft surfaces while the reinforced toe cap protects against rocks. The waterproof membrane keeps feet dry in stream crossings.' WHERE id = 97;
UPDATE products SET name = 'Zero Drop Natural', description = 'Marathon racing flat with a minimal 4mm drop for speed. The lightweight construction reduces fatigue during the final miles.' WHERE id = 98;
UPDATE products SET name = 'Max Cushion Jogger', description = 'Recovery shoe with arch support and cushioned footrest designed for post-run recuperation. The slip-on design makes transitions easy.' WHERE id = 99;
UPDATE products SET name = 'Speed Carbon Plate', description = 'Interval trainer with a responsive forefoot for quick acceleration. The durable rubber outsole withstands track surfaces and road mileage.' WHERE id = 100;
UPDATE products SET name = 'All-Terrain Trail Runner', description = 'Long-distance cruiser with plush heel cushioning and a smooth forefoot transition. The engineered mesh provides ventilation in hot conditions.' WHERE id = 101;
UPDATE products SET name = 'Lightweight Racing Shoe', description = 'Speed training shoe with a snappy plate that enhances toe-off power. The aerodynamic design reduces drag for competitive advantage.' WHERE id = 102;
UPDATE products SET name = 'Performance Tempo Runner', description = 'Hill training shoe with aggressive tread and reinforced toe for uphill power. The heel brake provides control during steep descents.' WHERE id = 103;
UPDATE products SET name = 'Recovery Easy Shoe', description = 'Recovery slide with contoured footbed that supports the arch and cushions the heel. Ideal for post-workout cooling down.' WHERE id = 104;
UPDATE products SET name = 'Interval Speed Trainer', description = 'Track spike with a rigid plate and replaceable spike pins. The minimal construction maximizes speed on synthetic surfaces.' WHERE id = 105;
UPDATE products SET name = 'Long Distance Marathon', description = 'Cross-country shoe with multi-directional lugs for grass and mud. The drainage ports expel water during wet race conditions.' WHERE id = 106;
UPDATE products SET name = 'Hill Climb Trail', description = 'Road racing shoe with a smooth outsole for efficient energy transfer. The streamlined design minimizes weight for PR attempts.' WHERE id = 107;
UPDATE products SET name = 'Mesh Active Trainer', description = 'Mesh quick-lace system replaces traditional laces for faster entry. The breathable upper keeps feet cool in warm conditions.' WHERE id = 108;
UPDATE products SET name = 'Leather Premium Sneaker', description = 'Leather slip-on with elastic gores for a secure, laceless fit. The cushioned insole provides comfort for all-day standing.' WHERE id = 109;
UPDATE products SET name = 'Woven Craft Original', description = 'Woven textile with a handcrafted appearance that distinguishes it from mass-produced sneakers. Each pair features unique weave variations.' WHERE id = 110;
UPDATE products SET name = 'Heritage Court Classic', description = 'Heritage court design with a low-top silhouette and gum rubber outsole. The classic styling transcends seasonal trends.' WHERE id = 111;
UPDATE products SET name = 'Retro Basketball Sneaker', description = 'Retro basketball sneaker with padded collar and tongue. The high-top design provides ankle support and vintage athletic appeal.' WHERE id = 112;
UPDATE products SET name = 'Urban Commuter Shoe', description = 'Urban commuter shoe with reflective details for low-light visibility. The waterproof upper handles unexpected rain during daily travels.' WHERE id = 113;
UPDATE products SET name = 'Platform Elevator Sneaker', description = 'Platform elevator sneaker with a concealed 3-inch lift. The chunky sole adds height while the classic upper maintains versatility.' WHERE id = 114;
UPDATE products SET name = 'Low-Top Canvas Original', description = 'Low-top canvas with a clean, unbranded design. The versatile silhouette works in casual offices and weekend settings.' WHERE id = 115;
UPDATE products SET name = 'Suede Sock Sneaker', description = 'Sock-fit sneaker with a seamless knit upper that eliminates pressure points. The stretchy collar provides a snug, sock-like feel.' WHERE id = 116;
UPDATE products SET name = 'Mesh Quick-Lace', description = 'Mesh active trainer with ventilation channels for maximum airflow. The quick-dry lining manages moisture during intense activity.' WHERE id = 117;
UPDATE products SET name = 'Leather Slip-On', description = 'Leather slip-on with a clean, polished appearance. The hand-stitched detailing adds artisan quality to the refined design.' WHERE id = 118;
UPDATE products SET name = 'Woven Comfort Sneaker', description = 'Comfort sneaker with arch support and cushioned heel cup. The ergonomic design reduces fatigue during extended standing.' WHERE id = 119;
UPDATE products SET name = 'Gold Chain Link Bracelet', description = 'Hand-polished gold-plated links catch light beautifully as they move. The lobster clasp closure ensures security while the 7.5-inch length fits most wrists comfortably.' WHERE id = 121;
UPDATE products SET name = 'Gemstone Charm Bracelet', description = 'Sterling silver chain with individually soldered links for maximum strength. The minimalist design pairs effortlessly with both casual and formal attire.' WHERE id = 122;
UPDATE products SET name = 'Tennis Diamond Bracelet', description = 'Vintage-inspired cuff with a hammered texture created by artisan metalworkers. The open design adjusts to fit various wrist sizes.' WHERE id = 123;
UPDATE products SET name = 'Leather Wrap Cuff', description = 'Freshwater pearls individually knotted on silk thread for security and elegant drape. The sterling silver clasp adds a refined finishing touch.' WHERE id = 124;
UPDATE products SET name = 'Bangle Stack Set', description = 'Crystal tennis bracelet with round-cut stones set in sterling silver. The flexible construction drapes naturally around the wrist.' WHERE id = 125;
UPDATE products SET name = 'Pearl Strand Bracelet', description = 'Braided leather cuff with a stainless steel buckle closure. The multi-strand design creates visual depth and texture.' WHERE id = 126;
UPDATE products SET name = 'Hammered Metal Cuff', description = 'Stackable bangle set with three coordinating widths. Mix and match for a layered look or wear individually for minimalist style.' WHERE id = 127;
UPDATE products SET name = 'Friendship Weave Bracelet', description = 'Friendship bracelet with hand-woven nylon threads in a traditional pattern. The adjustable knot closure fits any wrist size.' WHERE id = 128;
UPDATE products SET name = 'Toggle Chain Bracelet', description = 'Toggle closure bracelet with a decorative T-bar and ring. The bold hardware creates a statement focal point.' WHERE id = 129;
UPDATE products SET name = 'Diamond Cut Hoops', description = 'Diamond-cut hoops with faceted surfaces that reflect light brilliantly. The textured finish creates visual interest.' WHERE id = 130;
UPDATE products SET name = 'Vintage Filigree Drop', description = 'Vintage filigree drop with intricate metal scrollwork. The antique finish adds old-world charm to modern wardrobes.' WHERE id = 131;
UPDATE products SET name = 'Minimalist Bar Earrings', description = 'Minimalist bar earring with a horizontal gold bar. The clean lines suit contemporary and professional settings.' WHERE id = 132;
UPDATE products SET name = 'Bohemian Feather Drop', description = 'Feather drop earring with natural plume for bohemian styling. The lightweight construction ensures comfortable all-day wear.' WHERE id = 133;
UPDATE products SET name = 'Art Deco Geometric', description = 'Art deco geometric with stepped angles and clean lines. The geometric silhouette references 1920s glamour.' WHERE id = 134;
UPDATE products SET name = 'Celestial Moon Earrings', description = 'Crescent moon pendant earring with a celestial motif. The polished surface catches light for subtle shine.' WHERE id = 135;
UPDATE products SET name = 'Organic Leaf Drop', description = 'Leaf-shaped drop with organic, nature-inspired contours. The brushed finish adds a natural, earthy quality.' WHERE id = 136;
UPDATE products SET name = 'Sculptural Abstract Earrings', description = 'Sculptural abstract earring with an organic, freeform shape. The artistic design makes a bold statement.' WHERE id = 137;
UPDATE products SET name = 'Sculptural Chain Link', description = 'Sculptural chain link necklace with oversized, interlocking links. The bold construction makes a modern statement.' WHERE id = 138;
UPDATE products SET name = 'Classic Pearl Choker', description = 'Classic pearl choker with a single strand of Akoya pearls. The timeless design is appropriate for weddings and formal events.' WHERE id = 139;
UPDATE products SET name = 'Twisted Rope Necklace', description = 'Twisted rope chain with a braided texture that catches light from every angle. The substantial weight feels premium.' WHERE id = 140;
UPDATE products SET name = 'Enamel Color Pendant', description = 'Enamel color pendant with a bright, saturated hue. The glossy finish adds a playful pop to the neckline.' WHERE id = 141;
UPDATE products SET name = 'Twisted Rope Band', description = 'Twisted rope band with a braided texture. The detailed craftsmanship creates visual depth and interest.' WHERE id = 142;
UPDATE products SET name = 'Enamel Color Ring', description = 'Enamel color ring with a bright, saturated hue. The glossy finish adds playful vibrancy to the finger.' WHERE id = 143;
UPDATE products SET name = 'Hammered Gold Band', description = 'Hammered gold band with an organic texture. The warm tone flatters all skin tones.' WHERE id = 144;
UPDATE products SET name = 'Crystal Cluster Ring', description = 'Crystal cluster ring with multiple stones in an organic arrangement. The sparkling collection creates a dramatic focal point.' WHERE id = 145;
UPDATE products SET name = 'Vintage Locket Ring', description = 'Vintage locket ring with a hinged compartment. The hidden detail adds personal significance.' WHERE id = 146;
UPDATE products SET name = 'Modern Chain Ring', description = 'Modern chain ring with interlocking links. The contemporary design adds edge to the traditional band.' WHERE id = 147;
UPDATE products SET name = 'Nature Leaf Ring', description = 'Nature-inspired ring with organic forms and textures. The botanical motif brings natural beauty to the hand.' WHERE id = 148;
UPDATE products SET name = 'Celestial Moon Ring', description = 'Celestial moon ring with a crescent design. The symbolic piece adds whimsy and meaning.' WHERE id = 149;
UPDATE products SET name = 'Artisan Handcrafted Ring', description = 'Handcrafted artisan ring with visible hammering. The unique imperfections celebrate the human touch in creation.' WHERE id = 150;
UPDATE products SET name = 'Cocktail Statement Ring', description = 'Oversized cocktail ring with a faceted gemstone that catches light from every angle. The adjustable band accommodates different finger sizes.' WHERE id = 151;
UPDATE products SET name = 'Stackable Band Set', description = 'Set of five thin bands in mixed metals. Stack them all for maximum impact or wear individually for minimalist elegance.' WHERE id = 152;
UPDATE products SET name = 'Polarized Trail Blazer', description = 'Hand-polished crystal lenses deliver exceptional clarity in bright conditions. The brushed metal temples feature rubber-tipped ends for a secure, non-slip fit during active outdoor pursuits.' WHERE id = 153;
UPDATE products SET name = 'Retro Wave Spectacles', description = 'Inspired by vintage aviation design, these aviators feature teardrop-shaped lenses with anti-reflective coating. The adjustable nose pads ensure a customized fit for every face shape.' WHERE id = 154;
UPDATE products SET name = 'Summit Explorer Optics', description = 'Wraparound sport design provides full peripheral coverage and wind protection. The impact-resistant polycarbonate lenses meet military-grade standards, perfect for cycling, running, or hiking.' WHERE id = 155;
UPDATE products SET name = 'Urban Nomad Glasses', description = 'Retro-inspired round frames crafted from sustainable bio-acetate. The warm gradient tint adds a touch of sophistication while providing 100% UV protection for city strolls.' WHERE id = 156;
UPDATE products SET name = 'Coastal Drift Polarized', description = 'Minimalist wire-frame construction with spring-loaded hinges for effortless on-and-off. The polarized green lenses reduce eye strain during prolonged outdoor exposure.' WHERE id = 157;
UPDATE products SET name = 'Dusk Rider Shades', description = 'Oversized square frames make a dramatic fashion statement while offering maximum coverage. The scratch-resistant coating ensures lasting durability through daily adventures.' WHERE id = 158;
UPDATE products SET name = 'Alpine Summit Optics', description = 'Floating frame design creates an illusion of weightlessness. Temple tips feature grip-enhancing silicone for a secure fit during water sports and beach activities.' WHERE id = 159;
UPDATE products SET name = 'Pacific Breeze Sunglasses', description = 'Double-bridge aviator with mirrored blue lenses that shift color with the light. The stainless steel frame resists corrosion from saltwater and sweat.' WHERE id = 160;
UPDATE products SET name = 'Frontier Expedition Watch', description = 'Field watch with high-contrast dial and luminous Arabic numerals. The NATO strap provides reliable comfort in extreme outdoor conditions.' WHERE id = 161;
UPDATE products SET name = 'Sovereign Grand Complication', description = 'Dress watch with ultra-thin 6mm case that slides effortlessly under shirt cuffs. The Milanese mesh bracelet adjusts infinitely for perfect fit.' WHERE id = 162;
UPDATE products SET name = 'Ranger Survival Watch', description = 'Racing-inspired chronograph with carbon fiber dial and red accent hands. The rubber strap provides grip during high-speed activities.' WHERE id = 163;
UPDATE products SET name = 'Executive Dual Time', description = 'Aviation-style pilot watch with oversized crown designed for use with gloves. The large dial ensures readability at a glance in the cockpit.' WHERE id = 164;
UPDATE products SET name = 'Pioneer Altitude Watch', description = 'Vintage reissue with domed crystal and aged lume indices. The hand-stitched leather strap develops a unique patina over time.' WHERE id = 165;
UPDATE products SET name = 'Legacy Swiss Movement', description = 'Military-spec construction meets civilian elegance. The brushed steel case resists scratches while the exhibition caseback reveals precision engineering.' WHERE id = 166;
UPDATE products SET name = 'Zenith Precision Chrono', description = 'Perpetual calendar displays day, date, month, and leap year without adjustment until 2100. The moonphase window adds celestial elegance.' WHERE id = 167;
UPDATE products SET name = 'Crest Titanium Diver', description = 'Chronometer-certified movement accurate to -2/+2 seconds per day. The COSC certification guarantees precision and reliability.' WHERE id = 168;
UPDATE products SET name = 'Leather Hobo Relaxed', description = 'Leather hobo bag with a slouchy silhouette that drapes naturally. The spacious interior accommodates daily essentials and more.' WHERE id = 170;
UPDATE products SET name = 'Quilted Flap Chain', description = 'Quilted flap bag with a chain strap and turn-lock closure. The classic design transitions from day to evening seamlessly.' WHERE id = 171;
UPDATE products SET name = 'Canvas Market Tote', description = 'Canvas market tote with a wide opening for easy loading. The sturdy construction handles farmers market finds and daily errands.' WHERE id = 172;
UPDATE products SET name = 'Mini Bucket Bag', description = 'Mini bucket bag with a drawstring closure and compact silhouette. The petite size carries just the essentials.' WHERE id = 173;
UPDATE products SET name = 'Structured Work Tote', description = 'Structured work tote with padded laptop compartment and organizer pockets. The professional appearance suits office environments.' WHERE id = 174;
UPDATE products SET name = 'Saddle Western Bag', description = 'Saddle crossbody with Western-inspired stitching and a brass buckle. The vintage aesthetic adds character to modern outfits.' WHERE id = 175;
UPDATE products SET name = 'Woven Straw Beach', description = 'Woven straw beach bag with leather handles and trim. The natural fibers evoke coastal vacation vibes.' WHERE id = 176;
UPDATE products SET name = 'Convertible Weekender', description = 'Convertible weekender with a removable strap for shoulder or crossbody carry. The spacious interior handles overnight trips.' WHERE id = 177;
UPDATE products SET name = 'Metallic Envelope Clutch', description = 'Metallic envelope clutch with a sleek, folded design. The magnetic closure provides security while maintaining clean lines.' WHERE id = 178;
UPDATE products SET name = 'Fringe Suede Crossbody', description = 'Fringe suede crossbody with bohemian-inspired tassels. The soft suede develops a beautiful patina over time.' WHERE id = 179;
UPDATE products SET name = 'Geometric Hexagon Bag', description = 'Geometric hexagon bag with an unexpected shape. The structured design stands out from traditional silhouettes.' WHERE id = 180;
UPDATE products SET name = 'Leather Crossbody Classic', description = 'Full-grain leather crossbody with an adjustable strap that transitions from shoulder to crossbody wear. The organized interior features multiple card slots and a zippered coin pocket.' WHERE id = 181;
UPDATE products SET name = 'Quilted Shoulder Bag', description = 'Diamond-quilted shoulder bag with a chain-link strap that adds luxury detail. The magnetic snap closure provides quick access while the interior compartment keeps essentials organized.' WHERE id = 182;
UPDATE products SET name = 'Canvas Tote Everyday', description = 'Canvas tote with reinforced leather handles for comfortable carrying. The open-top design allows easy access while the interior zip pocket secures valuables.' WHERE id = 183;
UPDATE products SET name = 'Mini Chain Evening', description = 'Mini chain bag with a compact silhouette perfect for evening events. The gold-tone hardware adds luxury detail to the petite design.' WHERE id = 184;
UPDATE products SET name = 'Bucket Bag Bohemian', description = 'Bucket bag with a drawstring closure that creates a distinctive silhouette. The structured round base allows the bag to stand upright.' WHERE id = 185;
UPDATE products SET name = 'Structured Satchel Work', description = 'Structured satchel with a top handle and detachable crossbody strap for versatile carrying options. The organized interior includes a laptop sleeve.' WHERE id = 186;
UPDATE products SET name = 'Saddle Crossbody Retro', description = 'Saddle-shaped crossbody with a curved flap and equestrian-inspired buckle closure. The compact size carries essentials without bulk.' WHERE id = 187;
UPDATE products SET name = 'Peter Pan Collar Vintage', description = 'Peter Pan collar blouse with a rounded vintage-inspired collar. The sweet detail adds charm to the classic silhouette.' WHERE id = 188;
UPDATE products SET name = 'Embroidered Artisan Blouse', description = 'Embroidered blouse with floral threadwork across the yoke. The artisan-inspired craftsmanship adds unique character.' WHERE id = 189;
UPDATE products SET name = 'High Neck Satin Luxe', description = 'High neck satin blouse with a mandarin collar and back button closure. The structured fabric creates a polished appearance.' WHERE id = 190;
UPDATE products SET name = 'Peplum Waist Flattering', description = 'Peplum waist blouse with a structured flare that accentuates the waist. The tailored fit creates an hourglass silhouette.' WHERE id = 191;
UPDATE products SET name = 'Ribbed Racerback', description = 'Racerback construction with a sporty silhouette. The athletic design provides freedom of movement during activity.' WHERE id = 192;
UPDATE products SET name = 'Boho Crochet Crop', description = 'Crochet embroidered top with handmade open-work patterns. The artisan construction celebrates traditional craft.' WHERE id = 193;
UPDATE products SET name = 'Halter Backless Summer', description = 'Backless halter with a dramatic open back. The minimal front coverage creates a bold summer statement.' WHERE id = 194;
UPDATE products SET name = 'Crop Mock Neck', description = 'Mock neck crop with a high neckline that contrasts the cropped length. The modern silhouette balances coverage and exposure.' WHERE id = 195;
UPDATE products SET name = 'Long Sleeve Fitted', description = 'Fitted long sleeve with body-conscious stretch. The thumbhole cuffs add a sporty, functional detail.' WHERE id = 196;
UPDATE products SET name = 'Sweetheart Bustier', description = 'Bustier-style with structured boning and a corset-inspired silhouette. The romantic design makes a dramatic statement.' WHERE id = 197;
UPDATE products SET name = 'Asymmetric Draped', description = 'Draped asymmetric with fabric that cascades diagonally across the body. The fluid movement creates elegant folds.' WHERE id = 198;
UPDATE products SET name = 'Smocked Shrug Crop', description = 'Shrug-style crop with short sleeves and an open front. The layering piece adds warmth without coverage.' WHERE id = 199;
UPDATE products SET name = 'Tie Dye Ombre', description = 'Ombre tie-dye with a gradient color transition. The artistic pattern adds bohemian flair.' WHERE id = 200;
UPDATE products SET name = 'Square Neck Minimal', description = 'Minimalist square neck with clean lines and no embellishment. The understated design lets the silhouette speak.' WHERE id = 201;
UPDATE products SET name = 'Bralette Lace Trim', description = 'Lace-trimmed bralette with delicate scalloped edges. The feminine detail adds romance to the casual style.' WHERE id = 202;
UPDATE products SET name = 'Boho Lace Maxi', description = 'Lace maxi with all-over floral lace overlay. The romantic texture creates timeless elegance for formal events.' WHERE id = 203;
UPDATE products SET name = 'Sequin Halter Party', description = 'Halter sequin with a fitted bodice and flared skirt. The statement design ensures all eyes are on you.' WHERE id = 204;
UPDATE products SET name = 'Cotton Eyelet Summer', description = 'Eyelet cotton with broderie anglaise detailing. The summery texture creates fresh, feminine appeal.' WHERE id = 205;
UPDATE products SET name = 'Off Shoulder Ruffle', description = 'Off-shoulder ruffle with cascading tiers. The dramatic neckline highlights the collarbones and shoulders.' WHERE id = 206;
UPDATE products SET name = 'Pleated Satin Midi', description = 'Satin pleated midi with knife pleats that create elegant movement. The fluid fabric drapes beautifully.' WHERE id = 207;
UPDATE products SET name = 'Tiered Tulle Midi', description = 'Tulle tiered midi with layers of soft netting. The princess-inspired construction creates fairy-tale romance.' WHERE id = 208;
UPDATE products SET name = 'Slip Cowl Neck', description = 'Cowl-neck slip with a draped neckline and bias cut. The 1990s-inspired silhouette embodies minimalist cool.' WHERE id = 209;
UPDATE products SET name = 'Knit Ribbed Bodycon', description = 'Ribbed knit with a body-conscious fit. The textured fabric stretches to accommodate movement while maintaining shape.' WHERE id = 210;
UPDATE products SET name = 'Floral Maxi Garden', description = 'All-over floral print on flowing chiffon creates garden party elegance. The tiered skirt adds movement and romantic volume.' WHERE id = 211;
UPDATE products SET name = 'Wrap Midi Flattering', description = 'Wrap construction with a self-tie waist that adjusts for a customized fit. The universally flattering silhouette works for every body type.' WHERE id = 212;
UPDATE products SET name = 'A-Line Day Dress', description = 'A-line bodice with a fitted waist and flared skirt that skims the hips. The knee-length hem transitions from office to dinner.' WHERE id = 213;
UPDATE products SET name = 'Little Black Classic', description = 'Timeless sheath silhouette in solid black. The clean lines and cap sleeves create a sophisticated canvas for accessories.' WHERE id = 214;
UPDATE products SET name = 'Fit Flare Vintage', description = 'Fit-and-flare construction with a cinched waist and full swing skirt. The vintage-inspired silhouette creates an hourglass shape.' WHERE id = 215;
UPDATE products SET name = 'Shirt Dress Utility', description = 'Shirt dress with a button-front closure and self-fabric belt. The utility-inspired design works for casual and professional settings.' WHERE id = 216;
UPDATE products SET name = 'Bodycon Mini Statement', description = 'Bodycon silhouette in stretch jersey that hugs every curve. The figure-hugging design celebrates the feminine form.' WHERE id = 217;
UPDATE products SET name = 'Coastal Breeze Relaxed', description = 'Dark indigo rinse maintains a polished appearance suitable for casual offices. Contrast copper rivets add visual interest while reinforcing stress points.' WHERE id = 218;
UPDATE products SET name = 'Apex Performance Stretch', description = 'Light wash denim with sun-bleached tones perfect for summer. The soft hand feel comes from enzyme washing that breaks down surface fibers.' WHERE id = 219;
UPDATE products SET name = 'Artisan Crafted Denim', description = 'Slim fit with modern tapered leg from knee to hem. The 11.5oz weight strikes a balance between structure and comfort for year-round wear.' WHERE id = 220;
UPDATE products SET name = 'Ruched Bodycon Curve', description = 'Ruched bodycon with gathered side detailing that creates flattering texture. The curve-hugging fit celebrates the figure.' WHERE id = 221;
UPDATE products SET name = 'Pleated Satin Midi', description = 'Satin knife-pleated midi with structured folds. The fluid fabric creates elegant movement with each step.' WHERE id = 222;
UPDATE products SET name = 'A-Line Cotton Casual', description = 'Cotton A-line with a relaxed fit and knee-length hem. The casual style suits everyday wear.' WHERE id = 223;
UPDATE products SET name = 'Denim Mini Raw Hem', description = 'Raw-hem denim mini with a relaxed, lived-in feel. The unfinished edge adds casual, downtown cool.' WHERE id = 224;
UPDATE products SET name = 'High Waist Paper Bag', description = 'Paper bag waist with a ruched top and self-tie belt. The gathered waist creates a flattering, relaxed silhouette.' WHERE id = 225;
UPDATE products SET name = 'Wrap Tie Front', description = 'Tie-front with a crossover closure and bow detail. The feminine touch adds charm to the versatile design.' WHERE id = 226;
UPDATE products SET name = 'Tulle Knee Length', description = 'Tulle knee-length with soft netting that creates volume. The party-ready silhouette suits special occasions.' WHERE id = 227;
UPDATE products SET name = 'Leather Look Pencil', description = 'Leather-look pencil with a form-fitting silhouette. The sleek texture creates a polished, professional appearance.' WHERE id = 228;
UPDATE products SET name = 'Tweed Boucle Classic', description = 'Herringbone tweed with a classic pattern. The heritage fabric creates timeless, preppy sophistication.' WHERE id = 229;
UPDATE products SET name = 'Satin Draped Midi', description = 'Draped satin midi with fluid fabric that creates elegant folds. The Grecian-inspired draping adds sophistication.' WHERE id = 230;
UPDATE products SET name = 'Printed Wrap Midi', description = 'Printed wrap midi with a botanical pattern. The wrap construction flatters every body type.' WHERE id = 231;
UPDATE products SET name = 'High Waist Wide Cuff', description = 'High waist wide cuff with a structured hem. The tailored detail adds polish to the silhouette.' WHERE id = 232;
UPDATE products SET name = 'Wide Leg Chiffon Breeze', description = 'Chiffon wide-leg with an airy, flowing feel. The ethereal fabric creates dreamy movement.' WHERE id = 233;
UPDATE products SET name = 'Crepe Textured Finish', description = 'Textured crepe with a pebbled surface. The tactile fabric adds visual and physical interest.' WHERE id = 234;
UPDATE products SET name = 'Paper Bag Elastic Waist', description = 'Paper bag elastic with a comfortable, pull-on design. The easy-wear style suits everyday occasions.' WHERE id = 235;
UPDATE products SET name = 'Wide Leg Denim Casual', description = 'Denim wide-leg with a relaxed, casual silhouette. The familiar fabric creates approachable style.' WHERE id = 236;
UPDATE products SET name = 'Palazzo Silk Luxe', description = 'Silk palazzo with a luxurious drape and natural sheen. The premium fabric creates evening-worthy elegance.' WHERE id = 237;
UPDATE products SET name = 'High Waist Tapered', description = 'High waist tapered with a narrower leg opening. The modern silhouette balances wide-leg drama.' WHERE id = 238;
UPDATE products SET name = 'Western Heritage Boot', description = 'Shearling collar adds cozy warmth around the ankle while the leather upper provides structure and protection from the elements.' WHERE id = 239;
UPDATE products SET name = 'Shearling Cozy Boot', description = 'Hiking boot with a stability shank that prevents foot fatigue on long trails. The Gore-Tex lining ensures waterproof breathability.' WHERE id = 240;
UPDATE products SET name = 'Chelsea Leather Classic', description = 'Full-grain leather upper with a Chelsea boot silhouette featuring elastic side panels for easy on-and-off. The Goodyear welted construction allows resoling for years of extended wear.' WHERE id = 241;
UPDATE products SET name = 'Lace-Up Ankle Original', description = 'Premium suede upper with a crepe sole that provides cushioned comfort on hard surfaces. The chukka height offers ankle support without restricting movement.' WHERE id = 242;
UPDATE products SET name = 'Chukka Suede Heritage', description = 'Steel-reinforced toe cap meets ASTM safety standards for workplace protection. The waterproof leather upper and sealed seams keep feet dry in wet conditions.' WHERE id = 243;
UPDATE products SET name = 'Platform Statement Heel', description = 'Platform heel with a chunky sole that provides height without excessive pitch. The elevated front reduces strain on the ball of the foot.' WHERE id = 244;
UPDATE products SET name = 'Strappy Sandal Heel', description = 'Strappy sandal with thin straps that create an open, airy silhouette. The adjustable buckle ensures a secure fit.' WHERE id = 245;
UPDATE products SET name = 'Slingback Kitten Heel', description = 'Slingback with an elastic strap that hugs the heel. The kitten heel provides a subtle, comfortable lift.' WHERE id = 246;
UPDATE products SET name = 'Kitten Heel Subtle', description = 'Kitten heel with a modest 2-inch height. The subtle elevation provides elegance without sacrificing walking comfort.' WHERE id = 247;
UPDATE products SET name = 'Wedge Platform Comfort', description = 'Wedge heel with a continuous sole platform. The gradual slope provides height while distributing weight evenly.' WHERE id = 248;
UPDATE products SET name = 'Stiletto Suede Luxe', description = 'Suede stiletto with a matte texture that adds depth. The soft material creates a luxurious, tactile experience.' WHERE id = 249;
UPDATE products SET name = 'Block Heel Ankle Strap', description = 'Block heel ankle strap with a secure buckle closure. The 3-inch heel provides stable, comfortable elevation.' WHERE id = 250;
UPDATE products SET name = 'Pointed Toe Croco', description = 'Patent pointed toe with a croc-embossed texture. The exotic pattern adds visual interest to the glossy finish.' WHERE id = 251;

-- 2. Restore NOT NULL constraints on products.name and products.description.
--    These were deprecated in migration 024 as a transitional measure.
ALTER TABLE products ALTER COLUMN name SET NOT NULL;
ALTER TABLE products ALTER COLUMN description SET NOT NULL;

-- 3. Recreate the search_products RPC function without locale awareness.
--    Search operates directly on the products table (English only).
--    Replaces the locale-aware version from migration 024.
CREATE OR REPLACE FUNCTION search_products(
  p_query   TEXT,
  p_limit   INT DEFAULT 20,
  p_offset  INT DEFAULT 0
)
RETURNS TABLE (
  id              BIGINT,
  category_id     BIGINT,
  name            TEXT,
  description     TEXT,
  price           NUMERIC,
  discount_price  NUMERIC,
  brand           TEXT,
  thumbnail_url   TEXT,
  is_featured     BOOLEAN,
  is_available    BOOLEAN,
  total_count     BIGINT
)
LANGUAGE sql STABLE
AS $$
  WITH ranked AS (
    SELECT
      p.id,
      p.category_id,
      p.name,
      p.description,
      p.price,
      p.discount_price,
      p.brand,
      p.thumbnail_url,
      p.is_featured,
      p.is_available,
      COUNT(*) OVER () AS total_count
    FROM products p
    WHERE
      p.is_available = true
      AND (
        p.name ILIKE '%' || p_query || '%'
        OR p.brand ILIKE '%' || p_query || '%'
        OR p.description ILIKE '%' || p_query || '%'
      )
    ORDER BY
      CASE WHEN lower(p.name) = lower(p_query) THEN 0
           WHEN lower(p.name) LIKE lower(p_query) || '%' THEN 1
           ELSE 2
      END,
      similarity(p.name, p_query) DESC
  )
  SELECT
    id,
    category_id,
    name,
    description,
    price,
    discount_price,
    brand,
    thumbnail_url,
    is_featured,
    is_available,
    total_count
  FROM ranked
  ORDER BY
    CASE WHEN lower(name) = lower(p_query) THEN 0
         WHEN lower(name) LIKE lower(p_query) || '%' THEN 1
         ELSE 2
    END,
    similarity(name, p_query) DESC
  LIMIT p_limit OFFSET p_offset;
$$;

-- 4. Recreate the search_products_count RPC function without locale awareness.
CREATE OR REPLACE FUNCTION search_products_count(p_query TEXT)
RETURNS BIGINT
LANGUAGE sql STABLE
AS $$
  SELECT COUNT(*)
  FROM products
  WHERE
    is_available = true
    AND (
      name ILIKE '%' || p_query || '%'
      OR brand ILIKE '%' || p_query || '%'
      OR description ILIKE '%' || p_query || '%'
    );
$$;

-- 5. Remove locale-aware function overloads from migration 024.
DROP FUNCTION IF EXISTS search_products(TEXT, TEXT, INT, INT);
DROP FUNCTION IF EXISTS search_products_count(TEXT, TEXT);

-- 6. Drop the product_translations table and its dependencies.
--    All references have been removed from the codebase.
DROP TABLE IF EXISTS product_translations CASCADE;

COMMIT;
