module Element.Font exposing
    ( color, size
    , family, Font, typeface, serif, sansSerif, monospace
    , external, with, sizeByCapital
    , alignLeft, alignRight, center, justify, letterSpacing, wordSpacing
    , underline, strike, italic, unitalicized
    , heavy, extraBold, bold, semiBold, medium, regular, light, extraLight, hairline
    , glow, shadow
    )

{-|

    import Element
    import Element.Font as Font

    view =
        Element.el
            [ Font.color (Element.rgb 0 0 1)
            , Font.size 18
            , Font.family
                [ Font.typeface "Open Sans"
                , Font.sansSerif
                ]
            ]
            (Element.text "Woohoo, I'm stylish text")

**Note:** `Font.color`, `Font.size`, and `Font.family` are inherited, meaning you can set them at the top of your view and all subsequent nodes will have that value.

**Other Note:** If you're looking for something like `line-height`, it's handled by `Element.spacing` on a `paragraph`.

@docs color, size


## Typefaces

@docs family, Font, typeface, serif, sansSerif, monospace

@docs external, with, sizeByCapital

`Font.external` can be used to import font files. Let's say you found a neat font on <http://fonts.google.com>:

    import Element
    import Element.Font as Font

    view =
        Element.el
            [ Font.family
                [ Font.external
                    { name = "Roboto"
                    , url = "https://fonts.googleapis.com/css?family=Roboto"
                    }
                , Font.sansSerif
                ]
            ]
            (Element.text "Woohoo, I'm stylish text")


## Alignment and Spacing

@docs alignLeft, alignRight, center, justify, letterSpacing, wordSpacing


## Font Styles

@docs underline, strike, italic, unitalicized


## Font Weight

@docs heavy, extraBold, bold, semiBold, medium, regular, light, extraLight, hairline


## Shadows

@docs glow, shadow

-}

import Element exposing (Attr, Attribute, Color)
import Internal.Flag as Flag
import Internal.Model as Internal
import Internal.Style exposing (classes)


{-| -}
type alias Font =
    Internal.Font


{-| -}
color : Color -> Attr decorative msg
color fontColor =
    Internal.StyleClass Flag.fontColor (Internal.Colored ("fc-" ++ Internal.formatColorClass fontColor) "color" fontColor)


{-|

    import Element
    import Element.Font as Font

    myElement =
        Element.el
            [ Font.family
                [ Font.typeface "Helvetica"
                , Font.sansSerif
                ]
            ]
            (text "")

-}
family : List Font -> Attribute msg
family families =
    Internal.StyleClass Flag.fontFamily <| Internal.FontFamily (List.foldl Internal.renderFontClassName "ff-" families) families


{-| -}
serif : Font
serif =
    Internal.Serif


{-| -}
sansSerif : Font
sansSerif =
    Internal.SansSerif


{-| -}
monospace : Font
monospace =
    Internal.Monospace


{-| -}
typeface : String -> Font
typeface =
    Internal.Typeface


{-| -}
type alias Adjustment =
    { capital : Float
    , lowercase : Float
    , baseline : Float
    , descender : Float
    }


{-| -}
defaultAdjustment : Adjustment
defaultAdjustment =
    { capital = 1.0
    , lowercase = 0.5
    , baseline = 0.2
    , descender = 0
    }


{-| -}
with :
    { name : String
    , adjustment : Adjustment
    , url : Maybe String
    }
    -> Font
with =
    Internal.FontWith


{-| -}
sizeByCapital : Attribute msg
sizeByCapital =
    Internal.htmlClass classes.sizeByCapital


{-| -}
external : { url : String, name : String } -> Font
external { url, name } =
    Internal.ImportFont name url


{-| Font sizes are always given as `px`.
-}
size : Int -> Attr decorative msg
size i =
    Internal.StyleClass Flag.fontSize (Internal.FontSize i)


{-| In `px`.
-}
letterSpacing : Float -> Attribute msg
letterSpacing offset =
    Internal.StyleClass Flag.letterSpacing <|
        Internal.Single
            ("ls-" ++ Internal.floatClass offset)
            "letter-spacing"
            (String.fromFloat offset ++ "px")


{-| In `px`.
-}
wordSpacing : Float -> Attribute msg
wordSpacing offset =
    Internal.StyleClass Flag.wordSpacing <|
        Internal.Single ("ws-" ++ Internal.floatClass offset) "word-spacing" (String.fromFloat offset ++ "px")


{-| Align the font to the left.
-}
alignLeft : Attribute msg
alignLeft =
    Internal.Class Flag.fontAlignment classes.textLeft


{-| Align the font to the right.
-}
alignRight : Attribute msg
alignRight =
    Internal.Class Flag.fontAlignment classes.textRight


{-| Center align the font.
-}
center : Attribute msg
center =
    Internal.Class Flag.fontAlignment classes.textCenter


{-| -}
justify : Attribute msg
justify =
    Internal.Class Flag.fontAlignment classes.textJustify



-- {-| -}
-- justifyAll : Attribute msg
-- justifyAll =
--     Internal.class classesTextJustifyAll


{-| -}
underline : Attribute msg
underline =
    Internal.htmlClass classes.underline


{-| -}
strike : Attribute msg
strike =
    Internal.htmlClass classes.strike


{-| -}
italic : Attribute msg
italic =
    Internal.htmlClass classes.italic


{-| -}
bold : Attribute msg
bold =
    Internal.Class Flag.fontWeight classes.bold


{-| -}
light : Attribute msg
light =
    Internal.Class Flag.fontWeight classes.textLight


{-| -}
hairline : Attribute msg
hairline =
    Internal.Class Flag.fontWeight classes.textThin


{-| -}
extraLight : Attribute msg
extraLight =
    Internal.Class Flag.fontWeight classes.textExtraLight


{-| -}
regular : Attribute msg
regular =
    Internal.Class Flag.fontWeight classes.textNormalWeight


{-| -}
semiBold : Attribute msg
semiBold =
    Internal.Class Flag.fontWeight classes.textSemiBold


{-| -}
medium : Attribute msg
medium =
    Internal.Class Flag.fontWeight classes.textMedium


{-| -}
extraBold : Attribute msg
extraBold =
    Internal.Class Flag.fontWeight classes.textExtraBold


{-| -}
heavy : Attribute msg
heavy =
    Internal.Class Flag.fontWeight classes.textHeavy


{-| This will reset bold and italic.
-}
unitalicized : Attribute msg
unitalicized =
    Internal.htmlClass classes.textUnitalicized


{-| -}
shadow :
    { offset : ( Float, Float )
    , blur : Float
    , color : Color
    }
    -> Attr decorative msg
shadow shade =
    Internal.StyleClass Flag.txtShadows <|
        Internal.Single (Internal.textShadowName shade) "text-shadow" (Internal.formatTextShadow shade)


{-| A glow is just a simplified shadow.
-}
glow : Color -> Float -> Attr decorative msg
glow clr i =
    let
        shade =
            { offset = ( 0, 0 )
            , blur = i * 2
            , color = clr
            }
    in
    Internal.StyleClass Flag.txtShadows <|
        Internal.Single (Internal.textShadowName shade) "text-shadow" (Internal.formatTextShadow shade)
