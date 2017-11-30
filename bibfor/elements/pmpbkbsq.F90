! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine pmpbkbsq(skp, nbpout, yi, zi, sk)
    implicit none
!    -------------------------------------------------------------------
!     CALCUL DE LA MATRICE DE RIGIDE POUR ELEMENT SQUELETTE ASSEMBLAGE
!
!    -------------------------------------------------------------------

!   IN
!       skp(78,*) : tableau des matrices de rigidite des sous-poutres
!       nbpout    : nombre d assemblages de fibres
!       yi(*)     : position Y des sous-poutres
!       zi(*)     : position Z des sous-poutres
!
!   OUT
!       sk(171)       : matrice de rigidite


    integer :: ip(18), i, nbpout
    real(kind=8) :: sk(171), skp(78,*), yi(nbpout), zi(nbpout)

    data ip/0,1,3,6,10,15,21,28,36,45,55,66,78,91,105,120,136,153/

    do i =1 , nbpout
 
sk(ip(1)+1) = sk(ip(1)+1) + skp(ip(1)+ 1,i) ! M1= DFX/DU1 = K11
sk(ip(2)+1) = sk(ip(2)+1) + skp(ip(2)+ 1,i) ! M2 = DFY/DU1 = K21 = K12
sk(ip(2)+2) = sk(ip(2)+2) + skp(ip(2)+ 2,i) ! M3 = DFY/DV1 = K22
sk(ip(3)+1) = sk(ip(3)+1) + skp(ip(3)+ 1,i) ! M4 = DFZ/DU1 = K31 = K13
sk(ip(3)+2) = sk(ip(3)+2) + skp(ip(3)+ 2,i) ! M5 = DFZ/DV1 = K32 = K23
sk(ip(3)+3) = sk(ip(3)+3) + skp(ip(3)+ 3,i) ! M6 = DFZ/DW1 = K33

sk(ip(4)+1) = 0. ! M7 = DMX/DU1 = 0
sk(ip(4)+2) = 0. ! M8 = DMX/DV1 = 0
sk(ip(4)+3) = 0. ! M9 = DMX/DW1 = 0
sk(ip(4)+4) = sk(ip(4)+4) + skp(ip(4)+ 4,i) ! M10 = DMX/DTX1

sk(ip(5)+1) = sk(ip(5)+1) + skp(ip(5)+ 1,i) ! M11=DMY/DU1 = K51
sk(ip(5)+2) = sk(ip(5)+2) + skp(ip(5)+ 2,i) ! M12=DMY/DV1 = K52
sk(ip(5)+3) = sk(ip(5)+3) + skp(ip(5)+ 3,i) ! M13=DMY/DW1 = K53

sk(ip(5)+4) = 0.  ! M14 = DMY/DTX1 = 0

sk(ip(5)+5) = sk(ip(5)+5) + skp(ip(5)+ 5,i) ! M15 = DMY/DTY1 = K55

sk(ip(6)+1) = sk(ip(6)+1) + skp(ip(6)+ 1,i) ! M16 = DMZ/DU1 = K61
sk(ip(6)+2) = sk(ip(6)+2) + skp(ip(6)+ 2,i) ! M17 = DMZ/DV1 = K62
sk(ip(6)+3) = sk(ip(6)+3) + skp(ip(6)+ 3,i) ! M18 = DMZ/DW1 = K63
sk(ip(6)+4) = sk(ip(6)+4) + skp(ip(6)+ 4,i) ! M19 = DMZ/DTX1 = K64

sk(ip(6)+5) = sk(ip(6)+5) + skp(ip(6)+ 5,i) ! M20 = DMZ/DTY1 = K65
sk(ip(6)+6) = sk(ip(6)+6) + skp(ip(6)+ 6,i) ! M21 = DMZ/DTZ1 = K66

sk(ip(7)+1) = sk(ip(7)+1) + yi(i) *skp(ip(3)+ 1,i) - zi(i) *skp(ip(2)+ 1,i) ! M22 = DMGX/DU1 = Y*K31 -Z*K21
sk(ip(7)+2) = sk(ip(7)+2) + yi(i) *skp(ip(3)+ 2,i) - zi(i) *skp(ip(2)+ 2,i) ! M23 = DMGX/DV1 = Y*K32 -Z*K22
sk(ip(7)+3) = sk(ip(7)+3) + yi(i) *skp(ip(3)+ 3,i) - zi(i) *skp(ip(3)+ 2,i) ! M24 = DMGX/DW1 = Y*K33 -Z*K32

sk(ip(7)+4) = sk(ip(7)+4) + yi(i) *skp(ip(4)+ 3,i) - zi(i) *skp(ip(4)+ 2,i) ! M25 = DMGX/DTX1 = Y*K34-Z*K24
sk(ip(7)+5) = sk(ip(7)+5) + yi(i) *skp(ip(5)+ 3,i) - zi(i) *skp(ip(5)+ 2,i) ! M26 = DMGX/DTY1 = Y*K35-Z*K25
sk(ip(7)+6) = sk(ip(7)+6) + yi(i) *skp(ip(6)+ 3,i) - zi(i) *skp(ip(6)+ 2,i) ! M27 = DMGX/DTZ1 = Y*K36-Z*K26

sk(ip(7)+7) = sk(ip(7)+7) + yi(i) *(yi(i) *skp(ip(3)+ 3,i) - zi(i) *skp(ip(3)+ 2,i)) - &
                            zi(i) *(yi(i) *skp(ip(3)+ 2,i) - zi(i) *skp(ip(2)+ 2,i)) ! M28 = DMGX/DOMX1 = Y(Y*K33-Z*K32)-Z(Y*K23-Z*K22)

sk(ip(8)+1) = sk(ip(8)+1) + zi(i) *skp(ip(1)+ 1,i) ! M29 = DMGY/DU1 = Z*K11
sk(ip(8)+2) = sk(ip(8)+2) + zi(i) *skp(ip(2)+ 1,i) ! M30 = DMGY/DV1 = Z*K12
sk(ip(8)+3) = sk(ip(8)+3) + zi(i) *skp(ip(3)+ 1,i) ! M31 = DMGY/DW1 = Z*K13

sk(ip(8)+4) = sk(ip(8)+4) + zi(i) *skp(ip(4)+ 1,i) ! M32 = DMGY/DTX1 = Z*K14
sk(ip(8)+5) = sk(ip(8)+5) + zi(i) *skp(ip(5)+ 1,i) ! M33 = DMGY/DTY1 = Z*K15
sk(ip(8)+6) = sk(ip(8)+6) + zi(i) *skp(ip(6)+ 1,i) ! M34 = DMGY/DTZ1 = Z*K16

sk(ip(8)+7) = sk(ip(8)+7) + zi(i) *(yi(i) *skp(ip(3)+ 1,i) - zi(i) *skp(ip(2)+ 1,i)) ! M35 = DMGY/DOMX1 = Z*(-Z*K12+Y*K13)
sk(ip(8)+8) = sk(ip(8)+8) + zi(i) * zi(i) *skp(ip(1)+ 1,i) ! M36 = DMGY/DOMY1 = Z*(Z*K11)

sk(ip(9)+1) = sk(ip(9)+1) - yi(i)*skp(ip(1)+ 1,i) ! M37 = DMGZ/DU1 = -Y*K11
sk(ip(9)+2) = sk(ip(9)+2) - yi(i)*skp(ip(2)+ 1,i) ! M38 = DMGZ/DV1 = -Y*K12
sk(ip(9)+3) = sk(ip(9)+3) - yi(i)*skp(ip(3)+ 1,i) ! M39 = DMGZ/DW1 = -Y*K13

sk(ip(9)+4) = sk(ip(9)+4) - yi(i) *skp(ip(4)+ 1,i) ! M40 = DMGZ/DTX1 = -Y*K14
sk(ip(9)+5) = sk(ip(9)+5) - yi(i) *skp(ip(5)+ 1,i) ! M41 = DMGZ/DTY1 = -Y*K15
sk(ip(9)+6) = sk(ip(9)+6) - yi(i) *skp(ip(6)+ 1,i) ! M42 = DMGZ/DTZ1 = -Y*K16

sk(ip(9)+7) = sk(ip(9)+7) - yi(i) *(yi(i) *skp(ip(3)+ 1,i) - zi(i) *skp(ip(2)+ 1,i)) ! M43 = DMGZ/DOMX1 = -Y*(-Z*K12+Y*K13)
sk(ip(9)+8) = sk(ip(9)+8) - yi(i) * zi(i) *skp(ip(1)+ 1,i)  ! M44 = DMGZ/DOMY1 = -Y*( Z*K11)
sk(ip(9)+9) = sk(ip(9)+9) + yi(i) * yi(i) *skp(ip(1)+ 1,i)  ! M45 = DMGZ/DOMZ1 = -Y*(-Y*K11)

sk(ip(10)+1) = sk(ip(10)+1) + skp(ip(7)+ 1,i) ! M46 = DFX2/DU1 = K71
sk(ip(10)+2) = sk(ip(10)+2) + skp(ip(7)+ 2,i) ! M47 = DFX2/DV1 = K72
sk(ip(10)+3) = sk(ip(10)+3) + skp(ip(7)+ 3,i) ! M48 = DFX2/DW1 = K73

sk(ip(10)+4) = sk(ip(10)+4) + skp(ip(7)+ 4,i) ! M49 = DFX2/DTX1 = K47
sk(ip(10)+5) = sk(ip(10)+5) + skp(ip(7)+ 5,i) ! M50 = DFX2/DTY1 = K57
sk(ip(10)+6) = sk(ip(10)+6) + skp(ip(7)+ 6,i) ! M51 = DFX2/DTZ1 = K67

sk(ip(10)+7) = sk(ip(10)+7) + yi(i) *skp(ip(7)+ 3,i) - zi(i) *skp(ip(7)+ 2,i) ! M52 = DFX2/DOMX1= -Z*K72 + Y*K73
sk(ip(10)+8) = sk(ip(10)+8) + zi(i) *skp(ip(7)+ 1,i) ! M53 = DFX2/DOMY1= Z*K71 
sk(ip(10)+9) = sk(ip(10)+9) - yi(i) *skp(ip(7)+ 1,i) ! M54 = DFX2/DOMZ1= -Y*K71 

sk(ip(10)+10) = sk(ip(10)+10) + skp(ip(7)+ 7,i) ! M55 = DFX2/DU2 = K77

sk(ip(11)+1) = sk(ip(11)+1) + skp(ip(8)+ 1,i) ! M56 = DFY2/DU1 = K81
sk(ip(11)+2) = sk(ip(11)+2) + skp(ip(8)+ 2,i) ! M57 = DFY2/DV1 = K82
sk(ip(11)+3) = sk(ip(11)+3) + skp(ip(8)+ 3,i) ! M58 = DFY2/DW1 = K83

sk(ip(11)+4) = sk(ip(11)+4) + skp(ip(8)+ 4,i) ! M59 = DFY2/DTX1 = K84
sk(ip(11)+5) = sk(ip(11)+5) + skp(ip(8)+ 5,i) ! M60 = DFY2/DTY1 = K85
sk(ip(11)+6) = sk(ip(11)+6) + skp(ip(8)+ 6,i) ! M61 = DFY2/DTZ1 = K86

sk(ip(11)+7) = sk(ip(11)+7) - zi(i) *skp(ip(8)+ 2,i) + yi(i) *skp(ip(8)+ 3,i) ! M62 = DFY2/DOMX1 = -Z*K82 +Y*K83
sk(ip(11)+8) = sk(ip(11)+8) + zi(i) *skp(ip(8)+ 1,i)  ! M63 = DFY2/DOMY1 = Z*K81
sk(ip(11)+9) = sk(ip(11)+9) - yi(i) *skp(ip(8)+ 1,i)  ! M64 = DFY2/DOMZ1 = -Y*K81

sk(ip(11)+10) = sk(ip(11)+10) + skp(ip(8)+ 7,i) ! M65 = DFY2/DU2 = K87
sk(ip(11)+11) = sk(ip(11)+11) + skp(ip(8)+ 8,i) ! M66 = DFY2/DV2 = K88

sk(ip(12)+1) = sk(ip(12)+1) + skp(ip(9)+ 1,i) ! M67 = DFZ2/DU1 = K91
sk(ip(12)+2) = sk(ip(12)+2) + skp(ip(9)+ 2,i) ! M68 = DFZ2/DV1 = K92
sk(ip(12)+3) = sk(ip(12)+3) + skp(ip(9)+ 3,i) ! M69 = DFZ2/DW1 = K93

sk(ip(12)+4) = sk(ip(12)+4) + skp(ip(9)+ 4,i) ! M70 = DFZ2/DTX1 = K94
sk(ip(12)+5) = sk(ip(12)+5) + skp(ip(9)+ 5,i) ! M71 = DFZ2/DTY1 = K95
sk(ip(12)+6) = sk(ip(12)+6) + skp(ip(9)+ 6,i) ! M72 = DFZ2/DTZ1 = K96

sk(ip(12)+7) = sk(ip(12)+7) - zi(i) *skp(ip(9)+ 2,i) + yi(i) *skp(ip(9)+ 3,i) ! M73 = DFZ2/DOMX1 = -Z*K92 +Y*K93
sk(ip(12)+8) = sk(ip(12)+8) + zi(i) *skp(ip(9)+ 1,i)  ! M74 = DFZ2/DOMY1 = Z*K91
sk(ip(12)+9) = sk(ip(12)+9) - yi(i) *skp(ip(9)+ 1,i)  ! M75 = DFZ2/DOMZ1 = -Y*K91

sk(ip(12)+10) = sk(ip(12)+10) + skp(ip(9)+ 7,i) ! M76 = DFZ2/DU2 = K97
sk(ip(12)+11) = sk(ip(12)+11) + skp(ip(9)+ 8,i) ! M77 = DFZ2/DV2 = K98
sk(ip(12)+12) = sk(ip(12)+12) + skp(ip(9)+ 9,i) ! M78 = DFZ2/DV2 = K99

sk(ip(13)+1) = 0. ! M79 = DMX2/DU1 = 0
sk(ip(13)+2) = 0. ! M80 = DMX2/DV1 = 0
sk(ip(13)+3) = 0. ! M81 = DMX2/DW1 = 0

sk(ip(13)+4) = sk(ip(13)+4) + skp(ip(10)+ 4,i) ! M82 = DMX2/DTX1 = K10-4

sk(ip(13)+5) = 0. ! M83 = DMX2/DTY1 = 0
sk(ip(13)+6) = 0. ! M84 = DMX2/DTZ1 = 0

sk(ip(13)+7) = 0.! M85 = DMX2/DOMX1 = 0
sk(ip(13)+8) = 0.! M86 = DMX2/DOMY1 = 0
sk(ip(13)+9) = 0.! M87 = DMX2/DOMZ1 = 0

sk(ip(13)+10) = 0.! M88 = DMX2/DU2 = 0
sk(ip(13)+11) = 0.! M89 = DMX2/DV2 = 0
sk(ip(13)+12) = 0.! M90 = DMX2/DW2 = 0

sk(ip(13)+13) = sk(ip(13)+13) + skp(ip(10)+ 10,i) ! M91 = DMX2/DTX2 = K10-10

sk(ip(14)+1) = sk(ip(14)+1) + skp(ip(11)+ 1,i) ! M92 = DMY2/DU1 = K11-1
sk(ip(14)+2) = sk(ip(14)+2) + skp(ip(11)+ 2,i) ! M93 = DMY2/DV1 = K11-2
sk(ip(14)+3) = sk(ip(14)+3) + skp(ip(11)+ 3,i) ! M94 = DMY2/DW1 = K11-3

sk(ip(14)+4) = 0. ! M95 = DMY2/DTX1 = 0

sk(ip(14)+5) = sk(ip(14)+5) + skp(ip(11)+ 5,i) ! M96 = DMY2/DTY1 = K11-5 
sk(ip(14)+6) = sk(ip(14)+6) + skp(ip(11)+ 6,i) ! M97 = DMY2/DTZ1 = K11-6

sk(ip(14)+7) = sk(ip(14)+7) - zi(i) *skp(ip(11)+ 2,i) + yi(i) *skp(ip(11)+ 3,i) ! M98 = DMY2/DOMX1 = -Z*K11-2 + Y*K11-3
sk(ip(14)+8) = sk(ip(14)+8) + zi(i) *skp(ip(11)+ 1,i) ! M99 = DMY2/DOMY1 = Z*K11-1
sk(ip(14)+9) = sk(ip(14)+9) - yi(i) *skp(ip(11)+ 1,i) ! M100 = DMY2/DOMZ1 = -Y*K11-1

sk(ip(14)+10) = sk(ip(14)+10) + skp(ip(11)+ 7,i) ! M101 = DMY2/DU2 = K11-7
sk(ip(14)+11) = sk(ip(14)+11) + skp(ip(11)+ 8,i) ! M102 = DMY2/DV2 = K11-8
sk(ip(14)+12) = sk(ip(14)+12) + skp(ip(11)+ 9,i) ! M103 = DMY2/DW2 = K11-9

sk(ip(14)+13) = 0. ! M104 = DMY2/DTX2 = 0

sk(ip(14)+14) = sk(ip(14)+14) + skp(ip(11)+ 11,i) ! M105 = DMY2/DTY2 = K11-11

sk(ip(15)+1) = sk(ip(15)+1) + skp(ip(12)+ 1,i) ! M106 = DMZ2/DU1 = K12-1
sk(ip(15)+2) = sk(ip(15)+2) + skp(ip(12)+ 2,i) ! M107 = DMZ2/DV1 = K12-2
sk(ip(15)+3) = sk(ip(15)+3) + skp(ip(12)+ 3,i) ! M108 = DMZ2/DW1 = K12-3

sk(ip(15)+4) = sk(ip(15)+4) + skp(ip(12)+ 4,i) ! M109 = DMZ2/DTX1 = K12-4
sk(ip(15)+5) = sk(ip(15)+5) + skp(ip(12)+ 5,i) ! M110 = DMZ2/DTY1 = K12-5
sk(ip(15)+6) = sk(ip(15)+6) + skp(ip(12)+ 6,i) ! M111 = DMZ2/DTZ1 = K12-6

sk(ip(15)+7) = sk(ip(15)+7) - zi(i) *skp(ip(12)+ 2,i) + yi(i) *skp(ip(12)+ 3,i) ! M112 = DMZ2/DOMX1 = -Z*K12-2+Y*K12-3
sk(ip(15)+8) = sk(ip(15)+8) + zi(i) *skp(ip(12)+ 1,i)   ! M113 = DMZ2/DOMY1 = Z*K12-1
sk(ip(15)+9) = sk(ip(15)+9) - yi(i) *skp(ip(12)+ 1,i)   ! M114 = DMZ2/DOMZ1 = -Y*K12-1

sk(ip(15)+10) = sk(ip(15)+10) + skp(ip(12)+ 7,i) ! M115 = DMZ2/DU2 = K12-7
sk(ip(15)+11) = sk(ip(15)+11) + skp(ip(12)+ 8,i) ! M116 = DMZ2/DV2 = K12-8
sk(ip(15)+12) = sk(ip(15)+12) + skp(ip(12)+ 9,i) ! M117 = DMZ2/DW2 = K12-9

sk(ip(15)+13) = sk(ip(15)+13) + skp(ip(12)+ 10,i) ! M118 = DMZ2/DTX2 = K12-10
sk(ip(15)+14) = sk(ip(15)+14) + skp(ip(12)+ 11,i) ! M119 = DMZ2/DTY2 = K12-11
sk(ip(15)+15) = sk(ip(15)+15) + skp(ip(12)+ 12,i) ! M120 = DMZ2/DTY2 = K12-12

sk(ip(16)+1) = sk(ip(16)+1) + yi(i) *skp(ip(9)+ 1,i) - zi(i) *skp(ip(8)+ 1,i) ! M121 = DMGX2/DU1 = Y*K91 -Z*K81
sk(ip(16)+2) = sk(ip(16)+2) + yi(i) *skp(ip(9)+ 2,i) - zi(i) *skp(ip(8)+ 2,i) ! M122 = DMGX2/DV1 = Y*K92 -Z*K82
sk(ip(16)+3) = sk(ip(16)+3) + yi(i) *skp(ip(9)+ 3,i) - zi(i) *skp(ip(8)+ 3,i) ! M123 = DMGX2/DW1 = Y*K93 -Z*K83

sk(ip(16)+4) = sk(ip(16)+4) + yi(i) *skp(ip(9)+ 4,i) - zi(i) *skp(ip(8)+ 4,i) ! M124 = DMGX2/DTX1 = Y*K94-Z*K84
sk(ip(16)+5) = sk(ip(16)+5) + yi(i) *skp(ip(9)+ 5,i) - zi(i) *skp(ip(8)+ 5,i) ! M125 = DMGX2/DTY1 = Y*K95-Z*K85
sk(ip(16)+6) = sk(ip(16)+6) + yi(i) *skp(ip(9)+ 6,i) - zi(i) *skp(ip(8)+ 6,i) ! M126 = DMGX2/DTZ1 = Y*K96-Z*K86

sk(ip(16)+7) = sk(ip(16)+7) + yi(i) *(yi(i) *skp(ip(9)+ 3,i) - zi(i) *skp(ip(9)+ 2,i)) - &
                            zi(i) *(yi(i) *skp(ip(8)+ 3,i) - zi(i) *skp(ip(8)+ 2,i)) ! M127 = DMGX2/DOMX1 = Y(Y*K93-Z*K92)-Z(Y*K83-Z*K82)
sk(ip(16)+8) = sk(ip(16)+8) + yi(i) *(zi(i) *skp(ip(9)+ 1,i)) - &
                             zi(i) *(zi(i) *skp(ip(8)+ 1,i)) ! M128 = DMGX2/DOMY1 = Y(Z*K91)-Z(Z*K81)
sk(ip(16)+9) = sk(ip(16)+9) + yi(i) *(-yi(i) *skp(ip(9)+ 1,i)) - &
                             zi(i) *(-yi(i) *skp(ip(8)+ 1,i)) ! M129 = DMGX2/DOMZ1 = Y(-Y*K91)-Z(-Y*K81)

sk(ip(16)+10) = sk(ip(16)+10) + yi(i) *skp(ip(9)+ 7,i) - zi(i) *skp(ip(8)+ 7,i) ! M130 = DMGX2/DU2 = Y*K97 -Z*K87
sk(ip(16)+11) = sk(ip(16)+11) + yi(i) *skp(ip(9)+ 8,i) - zi(i) *skp(ip(8)+ 8,i) ! M131 = DMGX2/DV2 = Y*K98 -Z*K88
sk(ip(16)+12) = sk(ip(16)+12) + yi(i) *skp(ip(9)+ 9,i) - zi(i) *skp(ip(9)+ 8,i) ! M132 = DMGX2/DW2 = Y*K99 -Z*K89

sk(ip(16)+13) = sk(ip(16)+13) + yi(i) *skp(ip(10)+ 9,i) - zi(i) *skp(ip(10)+ 8,i) ! M133 = DMGX2/DTX2 = Y*K9-10 -Z*K8-10
sk(ip(16)+14) = sk(ip(16)+14) + yi(i) *skp(ip(11)+ 9,i) - zi(i) *skp(ip(11)+ 8,i) ! M134 = DMGX2/DTY2 = Y*K9-11 -Z*K8-11
sk(ip(16)+15) = sk(ip(16)+15) + yi(i) *skp(ip(12)+ 9,i) - zi(i) *skp(ip(12)+ 8,i) ! M135 = DMGX2/DTZ2 = Y*K9-12 -Z*K8-12

sk(ip(16)+16) = sk(ip(16)+16) + yi(i) *(yi(i) *skp(ip(9)+ 9,i) - zi(i) *skp(ip(9)+ 8,i)) - &
                            zi(i) *(yi(i) *skp(ip(9)+ 8,i) - zi(i) *skp(ip(8)+ 8,i)) ! M136 = DMGX2/DOMX2 = Y*(-Z*K98 +Y*K99) -Z*(-Z*K88 +Y*K89)

sk(ip(17)+1) = sk(ip(17)+1) + zi(i) *skp(ip(7)+ 1,i) ! M137 = DMGY2/DU1 = Z*K71 
sk(ip(17)+2) = sk(ip(17)+2) + zi(i) *skp(ip(7)+ 2,i) ! M138 = DMGY2/DV1 = Z*K72 
sk(ip(17)+3) = sk(ip(17)+3) + zi(i) *skp(ip(7)+ 3,i) ! M139 = DMGY2/DW1 = Z*K73 

sk(ip(17)+4) = sk(ip(17)+4) + zi(i) *skp(ip(7)+ 4,i) ! M140 = DMGY2/DTX1 = Z*K74
sk(ip(17)+5) = sk(ip(17)+5) + zi(i) *skp(ip(7)+ 5,i) ! M141 = DMGY2/DTY1 = Z*K75  
sk(ip(17)+6) = sk(ip(17)+6) + zi(i) *skp(ip(7)+ 6,i) ! M142 = DMGY2/DTZ1 = Z*K76 

sk(ip(17)+7) = sk(ip(17)+7) + zi(i) *(yi(i) *skp(ip(7)+ 3,i) - zi(i) *skp(ip(7)+ 2,i)) ! M143 = DMGY2/DOMX1 = Z*(-Z*K72+Y*K73)
sk(ip(17)+8) = sk(ip(17)+8) + zi(i) *(zi(i) *skp(ip(7)+ 1,i))  ! M144 = DMGY2/DOMY1 = Z*(Z*K71)
sk(ip(17)+9) = sk(ip(17)+9) + zi(i) *(-yi(i) *skp(ip(7)+ 1,i)) ! M145 = DMGY2/DOMZ1 = Z*(-Y*K71)

sk(ip(17)+10) = sk(ip(17)+10) + zi(i) *skp(ip(7)+ 7,i) ! M146 = DMGY2/DU2 = Z*K77
sk(ip(17)+11) = sk(ip(17)+11) + zi(i) *skp(ip(8)+ 7,i) ! M147 = DMGY2/DV2 = Z*K78
sk(ip(17)+12) = sk(ip(17)+12) + zi(i) *skp(ip(9)+ 7,i) ! M148 = DMGY2/DW2 = Z*K79

sk(ip(17)+13) = sk(ip(17)+13) + zi(i) *skp(ip(10)+ 7,i) ! M149 = DMGY2/DTX2 = Z*K7-10
sk(ip(17)+14) = sk(ip(17)+14) + zi(i) *skp(ip(11)+ 7,i) ! M150 = DMGY2/DTY2 = Z*K7-11
sk(ip(17)+15) = sk(ip(17)+15) + zi(i) *skp(ip(12)+ 7,i) ! M151 = DMGY2/DTZ2 = Z*K7-12

sk(ip(17)+16) = sk(ip(17)+16) + zi(i) *(yi(i) *skp(ip(9)+ 7,i) - zi(i) *skp(ip(8)+ 7,i)) ! M152 = DMGY2/DOMX2 = Z*(-Z*K78 +Y*K79)
sk(ip(17)+17) = sk(ip(17)+17) + zi(i) *(zi(i) *skp(ip(7)+ 7,i)) ! M153 = DMGY2/DOMY2 = Z*(Z*K77)

sk(ip(18)+1) = sk(ip(18)+1) - yi(i) *skp(ip(7)+ 1,i) ! M154 = DMGZ2/DU1 = -Y*K71 
sk(ip(18)+2) = sk(ip(18)+2) - yi(i) *skp(ip(7)+ 2,i) ! M155 = DMGZ2/DV1 = -Y*K72 
sk(ip(18)+3) = sk(ip(18)+3) - yi(i) *skp(ip(7)+ 3,i) ! M156 = DMGZ2/DW1 = -Y*K73 

sk(ip(18)+4) = sk(ip(18)+4) - yi(i) *skp(ip(7)+ 4,i) ! M157 = DMGZ2/DTX1 = -Y*K74
sk(ip(18)+5) = sk(ip(18)+5) - yi(i) *skp(ip(7)+ 5,i) ! M158 = DMGZ2/DTY1 = -Y*K75 
sk(ip(18)+6) = sk(ip(18)+6) - yi(i) *skp(ip(7)+ 6,i) ! M159 = DMGZ2/DTZ1 = -Y*K76 

sk(ip(18)+7) = sk(ip(18)+7) - yi(i) *(yi(i) *skp(ip(7)+ 3,i) - zi(i) *skp(ip(7)+ 2,i)) ! M160 = DMGZ2/DOMX1 = -Y*(-Z*K72+Y*K73)
sk(ip(18)+8) = sk(ip(18)+8) - yi(i) *(zi(i) *skp(ip(7)+ 1,i))  ! M161 = DMGZ2/DOMY1 = -Y*(Z*K71)
sk(ip(18)+9) = sk(ip(18)+9) - yi(i) *(-yi(i) *skp(ip(7)+ 1,i)) ! M162 = DMGZ2/DOMZ1 = -Y*(-Y*K71)

sk(ip(18)+10) = sk(ip(18)+10) - yi(i) *skp(ip(7)+ 7,i) ! M163 = DMGZ2/DU2 = -Y*K77
sk(ip(18)+11) = sk(ip(18)+11) - yi(i) *skp(ip(8)+ 7,i) ! M164 = DMGZ2/DV2 = -Y*K78
sk(ip(18)+12) = sk(ip(18)+12) - yi(i) *skp(ip(9)+ 7,i) ! M165 = DMGZ2/DW2 = -Y*K79

sk(ip(18)+13) = sk(ip(18)+13) - yi(i) *skp(ip(10)+ 7,i) ! M166 = DMGZ2/DTX2 = -Y*K7-10
sk(ip(18)+14) = sk(ip(18)+14) - yi(i) *skp(ip(11)+ 7,i) ! M167 = DMGZ2/DTY2 = -Y*K7-11
sk(ip(18)+15) = sk(ip(18)+15) - yi(i) *skp(ip(12)+ 7,i) ! M168 = DMGZ2/DTZ2 = -Y*K7-12

sk(ip(18)+16) = sk(ip(18)+16) - yi(i) *(yi(i) *skp(ip(9)+ 7,i) - zi(i) *skp(ip(8)+ 7,i)) ! M169 = DMGZ2/DOMX2 = -Y*(-Z*K78 +Y*K79)
sk(ip(18)+17) = sk(ip(18)+17) - yi(i) *(zi(i) *skp(ip(7)+ 7,i)) ! M170 = DMGZ2/DOMY2 = -Y*(Z*K77)
sk(ip(18)+18) = sk(ip(18)+18) - yi(i) *(-yi(i) *skp(ip(7)+ 7,i)) ! M171 = DMGZ2/DOMZ2 = -Y*(-Y*K77)

    enddo
end subroutine
