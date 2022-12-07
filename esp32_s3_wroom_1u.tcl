#*****************************************************************************
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Tue Dec 6 13:21:32 2022
#  Last Modified : <221207.1359>
#
#  Description	
#
#  Notes
#
#  History
#	
#*****************************************************************************
#
#    Copyright (C) 2022  Robert Heller D/B/A Deepwoods Software
#			51 Locke Hill Road
#			Wendell, MA 01379-9728
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# 
#
#*****************************************************************************


package require snit
source [file join [file dirname [info script]] ParseXML.tcl]

snit::type ESP32_S3_WROOM_PINS {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no
    
    typevariable height_ 19.20
    typemethod Height {} {return $height_}
    typevariable width_  18.00
    typemethod Width {} {return $width_}
    typevariable pitch_   1.27
    typemethod Pitch {} {return $pitch_}
    typevariable padNotchDiameter_ 0.55
    typemethod PadNotchDiameter {} {return $padNotchDiameter_}
    typevariable padOffsetFromBottom_ 1.5
    typemethod PadOffsetFromBottom {} {return $padOffsetFromBottom_}
    typevariable padSideSpan_ 16.51
    typemethod PadSideSpan {} {return $padSideSpan_}
    typevariable padWidth_ .9
    typemethod PadWidth {} {return $padWidth_}
    typevariable padDepth_ 0.45
    typemethod PadDepth {} {return $padDepth_}
    typevariable padHeight_ 1.5
    typemethod PadHeight {} {return $padHeight_}
    typevariable padCount_ 40
    typemethod PadCount {} {return $padCount_}
    typevariable leftSide_ {1 14}
    typemethod LeftSide {} {return $leftSide_}
    typevariable bottomSide_ {15 26}
    typemethod BottomSide {} {return $bottomSide_}
    typevariable rightSide_ {27 40}
    typemethod RightSide {} {return $rightSide_}
    typevariable leftRightBottomCNOffset_ 2.015
    typemethod LeftRightBottomCNOffset {} {return $leftRightBottomCNOffset_}
    typevariable padNames_ -array {
        1 GND
        2 3V3
        3 EN
        4 IO4
        5 IO5
        6 IO6
        7 IO7
        8 IO15
        9 IO16
        10 IO17
        11 IO18
        12 IO8
        13 IO19
        14 IO20
        15 IO3
        16 IO46
        17 IO9
        18 IO10
        19 IO11
        20 IO12
        21 IO13
        22 IO14
        23 IO21
        24 IO47
        25 IO48
        26 IO45
        27 IO0
        28 IO35
        29 IO36
        30 IO37
        31 IO38
        32 IO39
        33 IO40
        34 IO41
        35 IO42
        36 RXD0
        37 TXD0
        38 IO2
        39 IO1
        40 GND        
    }
    typemethod PadName {i} {return $padNames_($i)}
    typeconstructor {
    }
}
        

snit::type ESP32_S3_WROOM_SCHEMATIC {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no
    
    typecomponent svg
    typecomponent pins -inherit yes
    typevariable baseXML_ {<svg xmlns:svg='http://www.w3.org/2000/svg' 
                                xmlns='http://www.w3.org/2000/svg' 
                                version='1.2' 
                                width='7cm' height='6cm' 
                                viewBox="0 0 25000 24000" >
                                <g id="schematic" xmlns="http://www.w3.org/2000/svg" />
                            </svg>
                        }
    typevariable pinsidetopOrigY [expr {4100 + 500}]
    typevariable pinsidebottomOrigX [expr {4200+2000}]
    typevariable pinsidespacing  1000
    typevariable pinlength       2000
    typevariable pindiameter      250
    proc LeftPin {schemGroup relindex pinnumber pinname pinRightX pinOrig pinSpacing pinLength pinDiameter} {
        set pinY [expr {($relindex * $pinSpacing)+$pinOrig}]
        set pinline [SimpleDOMElement create %AUTO% -tag line \
                     -attributes [list \
                                  x1 [expr {$pinRightX - $pinLength}] \
                                  x2 $pinRightX \
                                  y1 $pinY y2 $pinY \
                                  fill none stroke-width 60 stroke black]]
        $schemGroup addchild $pinline
        set pinnameLabel [SimpleDOMElement create %AUTO% -tag text \
                          -attributes [list \
                                       font-family {Droid Sans} \
                                       font-size 500 \
                                       stroke none \
                                       fill black \
                                       text-anchor begin \
                                       x [expr {$pinRightX + 200}] \
                                       y [expr {$pinY + 200}]]]
        $pinnameLabel setdata $pinname
        $schemGroup addchild $pinnameLabel
        set pinnumberLabel [SimpleDOMElement create %AUTO% -tag text \
                            -attributes [list \
                                         font-family {Droid Sans} \
                                         font-size 500 \
                                         stroke none \
                                         fill black \
                                         text-anchor end \
                                         x [expr {$pinRightX -200}] \
                                         y [expr {$pinY - 200}]]]
        $pinnumberLabel setdata $pinnumber
        $schemGroup addchild $pinnumberLabel
        set connId [format "connector%spin" $pinnumber]
        set connX  [expr {$pinRightX - $pinLength - ($pinDiameter/2.0)}]
        set connY  $pinY
        set pinConnection [SimpleDOMElement create %AUTO% -tag circle \
                           -attributes [list \
                                        cx $connX \
                                        cy $connY \
                                        r  [expr {$pinDiameter / 2.0}] \
                                        id $connId \
                                        class pin \
                                        connectorname $pinnumber \
                                        fill none stroke-width 60 stroke black]]
        $schemGroup addchild $pinConnection
        set pinConnection [SimpleDOMElement create %AUTO% -tag rect \
                           -attributes [list \
                                        id $connId \
                                        fill none \
                                        x [expr {$connX - ($pinDiameter/2.0)}] \
                                        y [expr {$connY - ($pinDiameter/2.0)}] \
                                        class terminal \
                                        width $pinDiameter \
                                        height $pinDiameter \
                                        stroke none]]
        $schemGroup addchild $pinConnection
    }
    proc BottomPin {schemGroup relindex pinnumber pinname pinTopY pinOrig pinSpacing pinLength pinDiameter} {
        set pinX [expr {($relindex * $pinSpacing)+$pinOrig}]
        set pinline [SimpleDOMElement create %AUTO% -tag line \
                     -attributes [list \
                                  x1 $pinX x2 $pinX \
                                  y1 $pinTopY y2 [expr {$pinTopY + $pinLength}] \
                                  fill none stroke-width 60 stroke black]]
        $schemGroup addchild $pinline
        set pinnameLabel [SimpleDOMElement create %AUTO% -tag text \
                          -attributes [list \
                                       font-family {Droid Sans} \
                                       font-size 500 \
                                       stroke none \
                                       fill black \
                                       text-anchor begin \
                                       x 0 y 0]]
        $pinnameLabel setdata $pinname
        set rot90 [SimpleDOMElement create %AUTO% -tag g \
                   -attributes {transform rotate(270)}]
        $rot90 addchild $pinnameLabel
        set transform [SimpleDOMElement create %AUTO% -tag g \
                       -attributes [list \
                                    transform \
                                    [format {matrix(1, 0, 0, 1, %g, %g)} \
                                     [expr {$pinX + 200}] \
                                     [expr {$pinTopY - 200}]]]]
        $transform addchild $rot90
        $schemGroup addchild $transform
        set pinnumberLabel [SimpleDOMElement create %AUTO% -tag text \
                            -attributes [list \
                                         font-family {Droid Sans} \
                                         font-size 500 \
                                         stroke none \
                                         fill black \
                                         text-anchor end \
                                         x 0 y 0]]
        $pinnumberLabel setdata $pinnumber
        set rot90 [SimpleDOMElement create %AUTO% -tag g \
                   -attributes {transform rotate(270)}]
        $rot90 addchild $pinnumberLabel
        set transform [SimpleDOMElement create %AUTO% -tag g \
                       -attributes [list \
                                    transform \
                                    [format {matrix(1, 0, 0, 1, %g, %g)} \
                                     [expr {$pinX - 200}] \
                                     [expr {$pinTopY + 200}]]]]
        $transform addchild $rot90
        $schemGroup addchild $transform
        set connId [format "connector%spin" $pinnumber]
        set connX  $pinX
        set connY  [expr {$pinTopY + $pinLength + ($pinDiameter / 2.0)}]
        set pinConnection [SimpleDOMElement create %AUTO% -tag circle \
                           -attributes [list \
                                        cx $connX \
                                        cy $connY \
                                        r  [expr {$pinDiameter / 2.0}] \
                                        id $connId \
                                        class pin \
                                        connectorname $pinnumber \
                                        fill none stroke-width 60 stroke black]]
        $schemGroup addchild $pinConnection
        set pinConnection [SimpleDOMElement create %AUTO% -tag rect \
                           -attributes [list \
                                        id $connId \
                                        fill none \
                                        x [expr {$connX - ($pinDiameter/2.0)}] \
                                        y [expr {$connY - ($pinDiameter/2.0)}] \
                                        class terminal \
                                        width $pinDiameter \
                                        height $pinDiameter \
                                        stroke none]]
        $schemGroup addchild $pinConnection
    }
    proc RightPin {schemGroup relindex pinnumber pinname pinLeftX pinOrig pinSpacing pinLength pinDiameter} {
        set pinY [expr {($relindex * $pinSpacing)+$pinOrig}]
        set pinline [SimpleDOMElement create %AUTO% -tag line \
                     -attributes [list \
                                  x2 [expr {$pinLeftX + $pinLength}] \
                                  x1 $pinLeftX \
                                  y1 $pinY y2 $pinY \
                                  fill none stroke-width 60 stroke black]]
        $schemGroup addchild $pinline
        set pinnameLabel [SimpleDOMElement create %AUTO% -tag text \
                          -attributes [list \
                                       font-family {Droid Sans} \
                                       font-size 500 \
                                       stroke none \
                                       fill black \
                                       text-anchor end \
                                       x [expr {$pinLeftX - 200}] \
                                       y [expr {$pinY + 200}]]]
        $pinnameLabel setdata $pinname
        $schemGroup addchild $pinnameLabel
        set pinnumberLabel [SimpleDOMElement create %AUTO% -tag text \
                            -attributes [list \
                                         font-family {Droid Sans} \
                                         font-size 500 \
                                         stroke none \
                                         fill black \
                                         text-anchor begin \
                                         x [expr {$pinLeftX + 200}] \
                                         y [expr {$pinY - 200}]]]
        $pinnumberLabel setdata $pinnumber
        $schemGroup addchild $pinnumberLabel
        set connId [format "connector%spin" $pinnumber]
        set connX  [expr {$pinLeftX + $pinLength + ($pinDiameter/2.0)}]
        set connY  $pinY
        set pinConnection [SimpleDOMElement create %AUTO% -tag circle \
                           -attributes [list \
                                        cx $connX \
                                        cy $connY \
                                        r  [expr {$pinDiameter / 2.0}] \
                                        id $connId \
                                        class pin \
                                        connectorname $pinnumber \
                                        fill none stroke-width 60 stroke black]]
        $schemGroup addchild $pinConnection
        set pinConnection [SimpleDOMElement create %AUTO% -tag rect \
                           -attributes [list \
                                        id $connId \
                                        fill none \
                                        x [expr {$connX - ($pinDiameter/2.0)}] \
                                        y [expr {$connY - ($pinDiameter/2.0)}] \
                                        class terminal \
                                        width $pinDiameter \
                                        height $pinDiameter \
                                        stroke none]]
        $schemGroup addchild $pinConnection
    }
    typeconstructor {
        set svg [ParseXML %AUTO% $baseXML_]
        set pins ESP32_S3_WROOM_PINS
        set schemGroup [$svg getElementsById schematic]
        set body [SimpleDOMElement create %AUTO% -tag rect -attributes \
                  [list x 4200 y 4100 width 16000 height 15000 rx 0 fill none \
                   stroke-width 60 stroke black]]
        $schemGroup addchild $body
        set label [SimpleDOMElement create %AUTO% -tag text \
                   -attributes [list \
                                id label \
                                text-anchor middle \
                                x [expr {4200+8000}] \
                                y [expr {4100+7500}] \
                                font-size 2000 \
                                font-family {Droid Sans} \
                                stroke none \
                                fill black \
                                ]]
        $label setdata {ESP32 S3}
        $schemGroup addchild $label
        set label [SimpleDOMElement create %AUTO% -tag text \
                   -attributes [list \
                                id label \
                                text-anchor middle \
                                x [expr {4200+8000}] \
                                y [expr {(4100+7500)+2500}] \
                                font-size 2000 \
                                font-family {Droid Sans} \
                                stroke none \
                                fill black \
                                ]]
        $label setdata {WROOM}
        $schemGroup addchild $label
        
        lassign [$type LeftSide] first last
        set pin $first
        set i 0
        while {$pin <= $last} {
            LeftPin $schemGroup $i $pin [$type PadName $pin] 4200 $pinsidetopOrigY $pinsidespacing $pinlength $pindiameter
            incr i
            incr pin
        }
        lassign [$type BottomSide] first last
        set pin $first
        set i 0
        while {$pin <= $last} {
            BottomPin $schemGroup $i $pin [$type PadName $pin] [expr {4100+15000}] $pinsidebottomOrigX $pinsidespacing $pinlength $pindiameter 
            incr i
            incr pin
        }
        lassign [$type RightSide] first last
        set pin $last
        set i 0
        while {$pin >= $first} {
            RightPin $schemGroup $i $pin [$type PadName $pin] [expr {4200+16000}] $pinsidetopOrigY $pinsidespacing $pinlength $pindiameter
            incr i
            incr pin -1
        }
        set epadX [expr {4100+(15000/2.0)}]
        set epadY [expr {4200-$pinlength}]
        set pinline [SimpleDOMElement create %AUTO% -tag line \
                     -attributes [list \
                                  x1 $epadX y1 $epadY \
                                  x2 $epadX y2 4200 \
                                        fill none stroke-width 60 stroke black]]
        $schemGroup addchild $pinline
        set pinnameLabel [SimpleDOMElement create %AUTO% -tag text \
                          -attributes [list \
                                       font-family {Droid Sans} \
                                       font-size 500 \
                                       stroke none \
                                       fill black \
                                       text-anchor end \
                                       x 0 y 0]]
        $pinnameLabel setdata GND
        set rot90 [SimpleDOMElement create %AUTO% -tag g \
                   -attributes {transform rotate(270)}]
        $rot90 addchild $pinnameLabel
        set transform [SimpleDOMElement create %AUTO% -tag g \
                       -attributes [list \
                                    transform \
                                    [format {matrix(1, 0, 0, 1, %g, %g)} \
                                     [expr {$epadX + 200}] \
                                     [expr {4200 + 200}]]]]
        $transform addchild $rot90
        $schemGroup addchild $transform
        set pinnumberLabel [SimpleDOMElement create %AUTO% -tag text \
                            -attributes [list \
                                         font-family {Droid Sans} \
                                         font-size 500 \
                                         stroke none \
                                         fill black \
                                         text-anchor begin \
                                         x 0 y 0]]
        $pinnumberLabel setdata EPAD
        set rot90 [SimpleDOMElement create %AUTO% -tag g \
                   -attributes {transform rotate(270)}]
        $rot90 addchild $pinnumberLabel
        set transform [SimpleDOMElement create %AUTO% -tag g \
                       -attributes [list \
                                    transform \
                                    [format {matrix(1, 0, 0, 1, %g, %g)} \
                                     [expr {$epadX - 200}] \
                                     [expr {4200 - 200}]]]]
        $transform addchild $rot90
        $schemGroup addchild $transform
        set connId connector41pin
        set connX  $epadX
        set connY  [expr {$epadY - ($pindiameter / 2.0)}]
        set pinConnection [SimpleDOMElement create %AUTO% -tag circle \
                           -attributes [list \
                                        cx $connX \
                                        cy $connY \
                                        r  [expr {$pindiameter / 2.0}] \
                                        id $connId \
                                        class pin \
                                        connectorname EPAD \
                                        fill none stroke-width 60 stroke black]]
        $schemGroup addchild $pinConnection
        set pinConnection [SimpleDOMElement create %AUTO% -tag rect \
                           -attributes [list \
                                        id $connId \
                                        fill none \
                                        x [expr {$connX - ($pindiameter/2.0)}] \
                                        y [expr {$connY - ($pindiameter/2.0)}] \
                                        class terminal \
                                        width $pindiameter \
                                        height $pindiameter \
                                        stroke none]]
        $schemGroup addchild $pinConnection
                                     
    }
    typemethod WriteSchematicFile {filename} {
        set fp [open $filename w]
        $svg displayTree $fp
        close $fp
    }
}








snit::type ESP32_S3_WROOM_BREADBOARD {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no
    
    typecomponent svg
    typecomponent pins -inherit yes
    typevariable baseXML_ {<svg xmlns:svg='http://www.w3.org/2000/svg'
        xmlns='http://www.w3.org/2000/svg'
        version='1.2'
        width="18.0mm" height="19.2mm" viewBox="0 0 18 19.2">
        <g id="breadboard" />
        </svg>
    }
    typevariable outlinepath_
    typevariable outline_
    typemethod UpdateOutlinePath {pathelement} {
        append outlinepath_ $pathelement
        $outline_ setAttribute d $outlinepath_
    }
    typemethod LeftPin {bboardgroup relindex pinnumber pinname} {
        set topoffset   [expr {([$type Height]-[$type PadOffsetFromBottom])-[$type PadSideSpan]}]
        set notchCenter [expr {($relindex * [$type Pitch])+$topoffset}]
        set notchBottom [expr {$notchCenter + ([$type PadNotchDiameter]/2.0)}]
        set notchTop    [expr {$notchCenter - ([$type PadNotchDiameter]/2.0)}]
        set r           [expr {[$type PadNotchDiameter]/2.0}]
        $type UpdateOutlinePath [format { V%g} $notchTop]
        $type UpdateOutlinePath [format { a%g,%g,0,0,1,%g,%g}  \
                                 $r $r 0 [$type PadNotchDiameter]]
        set connId [format "connector%spin" $pinnumber]
        set connX  0
        set connY  $notchCenter
        set pinConnection [SimpleDOMElement create %AUTO% -tag circle \
                           -attributes [list \
                                        cx $connX \
                                        cy $connY \
                                        r  [expr {[$type PadNotchDiameter] / 2.0}] \
                                        id $connId \
                                        class pin \
                                        fill none stroke-width 0 stroke none]]
        $bboardgroup addchild $pinConnection
        set pinConnection [SimpleDOMElement create %AUTO% -tag rect \
                           -attributes [list \
                                        id $connId \
                                        fill none \
                                        x [expr {$connX - ([$type PadNotchDiameter]/2.0)}] \
                                        y [expr {$connY - ([$type PadNotchDiameter]/2.0)}] \
                                        class terminal \
                                        width [$type PadNotchDiameter] \
                                        height [$type PadNotchDiameter] \
                                        stroke none]]
        $bboardgroup addchild $pinConnection
    }
    typemethod BottomPin {bboardgroup relindex pinnumber pinname} {
        set notchCenter [expr {($relindex * [$type Pitch])+[$type LeftRightBottomCNOffset]}]
        set notchRight  [expr {$notchCenter + ([$type PadNotchDiameter]/2.0)}]
        set notchLeft   [expr {$notchCenter - ([$type PadNotchDiameter]/2.0)}]
        set r           [expr {[$type PadNotchDiameter]/2.0}]
        $type UpdateOutlinePath [format { H%g} $notchLeft]
        $type UpdateOutlinePath [format { a%g,%g,0,0,1,%g,%g}  \
                                 $r $r [$type PadNotchDiameter] 0]
        set connId [format "connector%spin" $pinnumber]
        set connX  $notchCenter
        set connY  19.2
        set pinConnection [SimpleDOMElement create %AUTO% -tag circle \
                           -attributes [list \
                                        cx $connX \
                                        cy $connY \
                                        r  [expr {[$type PadNotchDiameter] / 2.0}] \
                                        id $connId \
                                        class pin \
                                        fill none stroke-width 0 stroke none]]
        $bboardgroup addchild $pinConnection
        set pinConnection [SimpleDOMElement create %AUTO% -tag rect \
                           -attributes [list \
                                        id $connId \
                                        fill none \
                                        x [expr {$connX - ([$type PadNotchDiameter]/2.0)}] \
                                        y [expr {$connY - ([$type PadNotchDiameter]/2.0)}] \
                                        class terminal \
                                        width [$type PadNotchDiameter] \
                                        height [$type PadNotchDiameter] \
                                        stroke none]]
        $bboardgroup addchild $pinConnection
    }
    typemethod RightPin {bboardgroup relindex pinnumber pinname} {
        set topoffset   [expr {([$type Height]-[$type PadOffsetFromBottom])-[$type PadSideSpan]}]
        #puts stderr "*** $type RightPin: topoffset is $topoffset"
        set notchCenter [expr {($relindex * [$type Pitch])+$topoffset}]
        #puts stderr "*** $type RightPin: relindex is $relindex, notchCenter is $notchCenter"
        set notchBottom [expr {$notchCenter + ([$type PadNotchDiameter]/2.0)}]
        set notchTop    [expr {$notchCenter - ([$type PadNotchDiameter]/2.0)}]
        #puts stderr "*** $type RightPin: notchBottom is $notchBottom, notchTop is $notchTop"
        set r           [expr {[$type PadNotchDiameter]/2.0}]
        $type UpdateOutlinePath [format { V%g} $notchBottom]
        $type UpdateOutlinePath [format { a%g,%g,0,0,1,%g,%g}  \
                                 $r $r 0 -[$type PadNotchDiameter]]
        set connId [format "connector%spin" $pinnumber]
        set connX  18
        set connY  $notchCenter
        set pinConnection [SimpleDOMElement create %AUTO% -tag circle \
                           -attributes [list \
                                        cx $connX \
                                        cy $connY \
                                        r  [expr {[$type PadNotchDiameter] / 2.0}] \
                                        id $connId \
                                        class pin \
                                        fill none stroke-width 0 stroke none]]
        $bboardgroup addchild $pinConnection
        set pinConnection [SimpleDOMElement create %AUTO% -tag rect \
                           -attributes [list \
                                        id $connId \
                                        fill none \
                                        x [expr {$connX - ([$type PadNotchDiameter]/2.0)}] \
                                        y [expr {$connY - ([$type PadNotchDiameter]/2.0)}] \
                                        class terminal \
                                        width [$type PadNotchDiameter] \
                                        height [$type PadNotchDiameter] \
                                        stroke none]]
        $bboardgroup addchild $pinConnection
    }
    typeconstructor {
        set svg [ParseXML %AUTO% $baseXML_]
        set pins ESP32_S3_WROOM_PINS
        set bboardGroup [$svg getElementsById breadboard]
        set outlinepath_ "M0,0"
        set outline_ [SimpleDOMElement create %AUTO% -tag path \
                     -attributes [list \
                                  id outline \
                                  stroke-width .1 \
                                  stroke black \
                                  fill black \
                                  d $outlinepath_]]
        $bboardGroup addchild $outline_
        lassign [$type LeftSide] first last
        set pin $first
        set i 0
        while {$pin <= $last} {
            $type LeftPin $bboardGroup $i $pin [$type PadName $pin]
            incr i
            incr pin
        }
        $type UpdateOutlinePath { V19.2}
        lassign [$type BottomSide] first last
        set pin $first
        set i 0
        while {$pin <= $last} {
            $type BottomPin $bboardGroup $i $pin [$type PadName $pin]
            incr i
            incr pin
        }
        $type UpdateOutlinePath {H18}
        lassign [$type RightSide] first last
        set pin $first
        set i [expr {$last-$first}]
        while {$pin <= $last} {
            $type RightPin $bboardGroup $i $pin [$type PadName $pin]
            incr i -1
            incr pin
        }
        $type UpdateOutlinePath {V0z}
        set epadLeft [expr {7.5-(3.7/2.0)}]
        set epadTop  [expr {(19.2-10.29)-(3.7/2.0)}]
        set connId "connector41pin"
        set ePad [SimpleDOMElement create %AUTO% -tag rect \
                  -attributes [list \
                               x $epadLeft y $epadTop width 3.7 height 3.7 \
                               fill none stroke none \
                               id $connId \
                               connectorname epad]]
        $bboardGroup addchild $ePad
        set pinConnection [SimpleDOMElement create %AUTO% -tag rect \
                           -attributes [list \
                                        id $connId \
                                        fill none \
                                        x $epadLeft y $epadTop width 3.7 height 3.7 \
                                        class terminal \
                                        stroke none]]
        $bboardGroup addchild $pinConnection
        set coverpath [format {M%g,%g v-13.1 h%g v%g h-10.75 v17.5 z} \
                       [expr {18-1.08}] [expr {19.2-1.1}] \
                       [expr {-(15.65-10.75)}] \
                       [expr {-(17.5-13.1)}]]
        set cover [SimpleDOMElement create %AUTO% -tag path \
                   -attributes [list \
                                id cover \
                                stroke-width .2 \
                                stroke [format {#%02x%02x%02x} 47  79  79] \
                                fill [format {#%02x%02x%02x} 190 190 190] \
                                d $coverpath]]
        $bboardGroup addchild $cover
        set antennaConnector [SimpleDOMElement create %AUTO% -tag circle \
                              -attributes [list \
                                           id antenna \
                                           stroke-width .4 \
                                           cx 15 cy 2.46 r .9 \
                                           stroke [format {#%02x%02x%02x} \
                                                   188 143 143] \
                                           fill [format {#%02x%02x%02x} \
                                                 190 190 190] \
                                           ]]
        $bboardGroup addchild $antennaConnector
        set label [SimpleDOMElement create %AUTO% -tag text \
                   -attributes [list \
                                id label \
                                text-anchor middle \
                                x [expr {18 / 2.0}] \
                                y [expr {19.2 / 2.0}] \
                                font-size 3 \
                                font-family {Droid Sans} \
                                stroke none \
                                fill yellow \
                                ]]
        $label setdata {ESP32 S3}
        $bboardGroup addchild $label
        set label [SimpleDOMElement create %AUTO% -tag text \
                   -attributes [list \
                                id label \
                                text-anchor middle \
                                x [expr {18 / 2.0}] \
                                y [expr {(19.2 / 2.0)+3.1}] \
                                font-size 3 \
                                font-family {Droid Sans} \
                                stroke none \
                                fill yellow \
                                ]]
        $label setdata {WROOM}
        $bboardGroup addchild $label
    }
    typemethod WriteBreadboardFile {filename} {
        set fp [open $filename w]
        $svg displayTree $fp
        close $fp
    }
}

snit::type ESP32_S3_WROOM_PCB {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no
    
    typecomponent svg
    typecomponent pins -inherit yes
    typevariable baseXML_ {<svg xmlns:svg='http://www.w3.org/2000/svg'
        xmlns='http://www.w3.org/2000/svg'
        version='1.2'
        width="19.5mm" height="20.2mm" viewBox="-0.5 0 18.5 19.70">
        <g id="silkscreen" />
        <g id="copper1">
        <g id="copper0" />
        </g>
        </svg>
    }
    typemethod LeftPad {copper1 relindex pinnumber pinname} {
        set topoffset [expr {([$type Height]-[$type PadOffsetFromBottom])-[$type PadSideSpan]}]
        set padCenter [expr {($relindex * [$type Pitch])+$topoffset}]
        set padBottom [expr {$padCenter - ([$type PadWidth]/2.0)}]
        set padTop    [expr {$padCenter + ([$type PadWidth]/2.0)}]
        set padLeft  -.5
        set connId [format "connector%spin" $pinnumber]
        set pad [SimpleDOMElement create %AUTO% -tag rect \
                 -attributes [list \
                              x $padLeft y $padBottom \
                              width [$type PadHeight] \
                              height [$type PadWidth] \
                              fill #ffbf00 stroke none \
                              id $connId \
                              connectorname $pinnumber]]
        $copper1 addchild $pad
    }
    typemethod RightPad {copper1 relindex pinnumber pinname} {
        set topoffset [expr {([$type Height]-[$type PadOffsetFromBottom])-[$type PadSideSpan]}]
        set padCenter [expr {($relindex * [$type Pitch])+$topoffset}]
        set padBottom [expr {$padCenter - ([$type PadWidth]/2.0)}]
        set padTop    [expr {$padCenter + ([$type PadWidth]/2.0)}]
        set padLeft   [expr {18.5 - [$type PadHeight]}]
        set connId [format "connector%spin" $pinnumber]
        set pad [SimpleDOMElement create %AUTO% -tag rect \
                 -attributes [list \
                              x $padLeft y $padBottom \
                              width [$type PadHeight] \
                              height [$type PadWidth] \
                              fill #ffbf00 stroke none \
                              id $connId \
                              connectorname $pinnumber]]
        $copper1 addchild $pad
    }
    typemethod BottomPad {copper1 relindex pinnumber pinname} {
        set padCenter [expr {($relindex * [$type Pitch])+[$type LeftRightBottomCNOffset]}]
        set padLeft   [expr {$padCenter - ([$type PadWidth]/2.0)}]
        set padRight  [expr {$padCenter + ([$type PadWidth]/2.0)}]
        set padBottom [expr {19.7 - [$type PadHeight]}]
        set connId [format "connector%spin" $pinnumber]
        set pad [SimpleDOMElement create %AUTO% -tag rect \
                 -attributes [list \
                              x $padLeft y $padBottom \
                              width [$type PadWidth] \
                              height [$type PadHeight] \
                              fill #ffbf00 stroke none \
                              id $connId \
                              connectorname $pinnumber]]
        $copper1 addchild $pad
    }
    typeconstructor {
        set svg [ParseXML %AUTO% $baseXML_]
        set pins ESP32_S3_WROOM_PINS
        set silk [$svg getElementsById silkscreen]
        set fc   [$svg getElementsById copper1]
        set bc   [$svg getElementsById copper0]
        set bodySilk [SimpleDOMElement create %AUTO% -tag rect \
                      -attributes [list \
                                   x 0 y 0 \
                                   width [$type Width] height [$type Height] \
                                   fill none stroke white \
                                   stroke-width .2]]
        $silk addchild $bodySilk
        set label [SimpleDOMElement create %AUTO% -tag text \
                   -attributes [list \
                                id label \
                                text-anchor middle \
                                x [expr {18 / 2.0}] \
                                y [expr {(19.2 / 2.0)-4}] \
                                font-size 3 \
                                font-family {Droid Sans} \
                                stroke none \
                                fill white \
                                ]]
        $label setdata {ESP32 S3}
        $silk addchild $label
        set label [SimpleDOMElement create %AUTO% -tag text \
                   -attributes [list \
                                id label \
                                text-anchor middle \
                                x [expr {18 / 2.0}] \
                                y [expr {(19.2 / 2.0)+4}] \
                                font-size 3 \
                                font-family {Droid Sans} \
                                stroke none \
                                fill white \
                                ]]
        $label setdata {WROOM}
        $silk addchild $label
        lassign [$type LeftSide] first last
        set pin $first
        set i 0
        while {$pin <= $last} {
            $type LeftPad $fc $i $pin [$type PadName $pin]
            incr i
            incr pin
        }
        lassign [$type RightSide] first last
        set pin $last
        set i 0
        while {$pin >= $first} {
            $type RightPad $fc $i $pin [$type PadName $pin]
            incr i
            incr pin -1
        }
        lassign [$type BottomSide] first last
        set pin $first
        set i 0
        while {$pin <= $last} {
            $type BottomPad $fc $i $pin [$type PadName $pin]
            incr i
            incr pin
        }
        set epadLeft [expr {7.5-(3.7/2.0)}]
        set epadTop  [expr {(19.2-10.29)-(3.7/2.0)}]
        set connId "connector41pin"
        set ePad [SimpleDOMElement create %AUTO% -tag rect \
                  -attributes [list \
                               x $epadLeft y $epadTop width 3.7 height 3.7 \
                               fill #ffbf00 stroke none \
                               id $connId \
                               connectorname epad]]
        $fc addchild $ePad
        set vcy [expr {19.2-10.29}]
        set vcx 7.5
        for {set i -1} {$i < 2} {incr i} {
            set vy [expr {($i*.9)+$vcy}]
            for {set j -1} {$j < 2} {incr j} {
                set vx [expr {($j*.9)+$vcx}]
                set eVia [SimpleDOMElement create %AUTO% -tag circle \
                          -attributes [list \
                                       cx $vx cy $vy r .4 \
                                       stroke #ffbf00 fill none \
                                       stroke-width .2 \
                                       id $connId \
                                       connectorname epad]]
                $bc addchild $eVia
            }
        }
    }
    typemethod WritePCBFile {filename} {
        set fp [open $filename w]
        $svg displayTree $fp
        close $fp
    }
}

snit::type ESP32_S3_WROOM_PART {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no
    
    typecomponent part
    typecomponent pins -inherit yes
    typecomponent breadboard
    typecomponent schematic
    typecomponent pcb
    typevariable tags_ [list {ESP32-S3} {WROOM}]
    typevariable properties_ -array {
        family {ESP32 S3} variant {WROOM 1U} package {WROOM 1U} 
        pins 40 {chip label} {ESP32 S3} {editable pin labels} false
    }
    typevariable description_ {}
    typevariable baseXML_ {<module moduleId="esp32_s3_wroom_1u"/>}
    typeconstructor {
        set part [ParseXML %AUTO% $baseXML_]
        set pins ESP32_S3_WROOM_PINS
        set breadboard ESP32_S3_WROOM_BREADBOARD
        set schematic ESP32_S3_WROOM_SCHEMATIC
        set pcb ESP32_S3_WROOM_PCB
        set module [$part getElementsByTagName module]
        set basefilename [$module attribute moduleId]
        set version [SimpleDOMElement create %AUTO% -tag version]
        $version setdata {1.0}
        $module addchild $version
        set author [SimpleDOMElement create %AUTO% -tag author]
        $author setdata {Robert Heller}
        $module addchild $author
        set title [SimpleDOMElement create %AUTO% -tag title]
        $title setdata {ESP32_S3_WROOM_1U}
        $module addchild $title
        set date [SimpleDOMElement create %AUTO% -tag date]
        $date setdata [clock format [clock scan now]]
        $module addchild $date
        set label [SimpleDOMElement create %AUTO% -tag label]
        $label setdata {ESP32_S3_WROOM_1U}
        $module addchild $label
        set tags [SimpleDOMElement create %AUTO% -tag tags]
        $module addchild $tags
        foreach t $tags_ {
            set tag [SimpleDOMElement create %AUTO% -tag tag]
            $tag setdata $t
            $tags addchild $tag
        }
        set properties [SimpleDOMElement create %AUTO% -tag properties]
        $module addchild $properties
        foreach p [array name properties_] {
            set prop [SimpleDOMElement create %AUTO% -tag property \
                      -attributes [list name $p]]
            $prop setdata $properties_($p)
            $properties addchild $prop
        }
        $module addchild [SimpleDOMElement create %AUTO% -tag taxonomy]
        set description [SimpleDOMElement create %AUTO% -tag description]
        $description setdata $description_
        $module addchild $description
        set views [SimpleDOMElement create %AUTO% -tag views]
        $module addchild $views
        set icon [SimpleDOMElement create %AUTO% -tag iconView]
        $views addchild $icon
        set layers [SimpleDOMElement create %AUTO% -tag layers \
                    -attributes [list image [file join breadboard \
                                             ${basefilename}.svg]]]
        $icon addchild $layers
        set layer [SimpleDOMElement create %AUTO% -tag layer \
                   -attributes [list layerId icon]]
        $layers addchild $layer
        set bboard [SimpleDOMElement create %AUTO% -tag breadboardView]
        $views addchild $bboard
        set layers [SimpleDOMElement create %AUTO% -tag layers \
                    -attributes [list image [file join breadboard \
                                             ${basefilename}.svg]]]
        $bboard addchild $layers
        set layer [SimpleDOMElement create %AUTO% -tag layer \
                   -attributes [list layerId breadboard]]
        $layers addchild $layer
        set schem [SimpleDOMElement create %AUTO% -tag schematicView]
        $views addchild $schem
        set layers [SimpleDOMElement create %AUTO% -tag layers \
                    -attributes [list image [file join schematic \
                                             ${basefilename}.svg]]]
        $schem addchild $layers
        set layer [SimpleDOMElement create %AUTO% -tag layer \
                   -attributes [list layerId schematic]]
        $layers addchild $layer
        set pcbview [SimpleDOMElement create %AUTO% -tag pcbView]
        $views addchild $pcbview
        set layers [SimpleDOMElement create %AUTO% -tag layers \
                    -attributes [list image [file join pcb \
                                             ${basefilename}.svg]]]
        $pcbview addchild $layers
        set layer [SimpleDOMElement create %AUTO% -tag layer \
                   -attributes [list \
                                layerId silkscreen \
                                layerId copper0 \
                                layerId copper1 \
                                ]]
        $layers addchild $layer
        set connectors [SimpleDOMElement create %AUTO% -tag connectors]
        $module addchild $connectors
        for {set i 1} {$i <= 40} {incr i} {
            set conn [SimpleDOMElement create %AUTO% -tag connector \
                      -attributes [list \
                                   name [format {pin %d} $i] \
                                   type male \
                                   id [format {connector%d} $i] \
                                   ]]
            $connectors addchild $conn
            set descr [SimpleDOMElement create %AUTO% -tag description]
            set connid [format {connector%spin} $i]
            $descr setdata [$type PadName $i]
            $conn addchild $descr
            set cviews [SimpleDOMElement create %AUTO% -tag views]
            $conn addchild $cviews
            set bview [SimpleDOMElement create %AUTO% -tag breadboardView]
            $cviews addchild $bview
            set p [SimpleDOMElement create %AUTO% -tag p \
                   -attributes [list svgId $connid layer breadboard]]
            $bview addchild $p
            set sview [SimpleDOMElement create %AUTO% -tag schematicView]
            $cviews addchild $sview
            set p [SimpleDOMElement create %AUTO% -tag p \
                   -attributes [list svgId $connid layer schematic]]
            $sview addchild $p
            set pview [SimpleDOMElement create %AUTO% -tag pcbView]
            $cviews addchild $pview
            set p [SimpleDOMElement create %AUTO% -tag p \
                   -attributes [list svgId $connid layer copper1]]
            $pview addchild $p
        }
        set conn [SimpleDOMElement create %AUTO% -tag connector \
                  -attributes [list \
                               name EPAD \
                               type male \
                               id connector41]]
        $connectors addchild $conn
        set descr [SimpleDOMElement create %AUTO% -tag description]
        $descr setdata GND
        $conn addchild $descr
        set cviews [SimpleDOMElement create %AUTO% -tag views]
        set connid connector41pin
        set cviews [SimpleDOMElement create %AUTO% -tag views]
        $conn addchild $cviews
        set bview [SimpleDOMElement create %AUTO% -tag breadboardView]
        $cviews addchild $bview
        set p [SimpleDOMElement create %AUTO% -tag p \
               -attributes [list svgId $connid layer breadboard]]
        $bview addchild $p
        set sview [SimpleDOMElement create %AUTO% -tag schematicView]
        $cviews addchild $sview
        set p [SimpleDOMElement create %AUTO% -tag p \
               -attributes [list svgId $connid layer schematic]]
        $sview addchild $p
        set pview [SimpleDOMElement create %AUTO% -tag pcbView]
        $cviews addchild $pview
        set p [SimpleDOMElement create %AUTO% -tag p \
               -attributes [list svgId $connid layer copper1]]
        $pview addchild $p
        set p [SimpleDOMElement create %AUTO% -tag p \
               -attributes [list svgId $connid layer copper0]]
        $pview addchild $p
    }
    typemethod WritePartFile {tempdir} {
        if {[file isdirectory $tempdir]} {
            foreach f [glob -nocomplain [file join $tempdir *]] {
                file delete -force $f
            }
        } else {
            file mkdir $tempdir
        }
        set module [$part getElementsByTagName module]
        set basefilename [$module attribute moduleId]
        $breadboard WriteBreadboardFile [file join $tempdir svg.breadboard.${basefilename}.svg]
        $schematic WriteSchematicFile [file join $tempdir svg.schematic.${basefilename}.svg]
        $pcb WritePCBFile [file join $tempdir svg.pcb.${basefilename}.svg]
        set fp [open [file join $tempdir part.${basefilename}.fzp] w]
        $part displayTree $fp
        close $fp
        file delete -force ${basefilename}.fzpz
        exec {*}[list zip -qqj ${basefilename}.fzpz -r $tempdir]
    }
}

ESP32_S3_WROOM_PART WritePartFile ESP32-S3-WROOM-1U
