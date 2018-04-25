! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine burftm(cmp, ndim, vim, epsfm)
! person_in_charge: alexandre.foucault at edf.fr
! ----------------------------------------------------------------------
! ROUTINE DE COMPORTEMENT DE FLUAGE BETON_BURGER
! PASSAGE DES VARIABLES INTERNES AU VECTEUR DE DEFORMATIONS DE FLUAGE
!
! IN  CMP : COMPOSANTES A CALCULER :
!             'FT' : FLUAGE PROPRE + DESSICCATION
!             'FP' : FLUAGE PROPRE UNIQUEMENT
!             'FD' : FLUAGE DE DESSICCATION
!     NDIM  : DIMENSION DU PROBLEME (2D OU 3D)
!     VIM   : VARIABLES INTERNES
! OUT EPSFM : VECTEUR DE DEFORMATIONS DE FLUAGE
!
!  STRUCTURE DES VARIABLES INTERNES MFRONT : VIM,VIP ( X = I ou F )
!
!     DANS LE CAS 2D :
!     VIX(1)     = ElasticStrainXX : DEFORMATION ELASTIQUE 11
!     VIX(2)     = ElasticStrainYY : DEFORMATION ELASTIQUE 22
!     VIX(3)     = ElasticStrainZZ : DEFORMATION ELASTIQUE 33
!     VIX(4)     = ElasticStrainXY : DEFORMATION ELASTIQUE 12
!     VIX(5)     = ESPHR   : DEFORMATION DE FLUAGE REV SPHERIQUE
!     VIX(6)     = ESPHI   : DEFORMATION DE FLUAGE IRR SPHERIQUE
!     VIX(7)     = ELIM    : DEF. EQUIVALENTE DU FP IRREVERSIBLE MAX
!     VIX(8)    = EDEVRXX : DEFORMATION DE FLUAGE REV DEVIATORIQUE 11
!     VIX(9)    = EDEVRYY : DEFORMATION DE FLUAGE REV DEVIATORIQUE 22
!     VIX(10)    = EDEVRZZ : DEFORMATION DE FLUAGE REV DEVIATORIQUE 33
!     VIX(11)    = EDEVRXY : DEFORMATION DE FLUAGE REV DEVIATORIQUE 12
!     VIX(12)    = EDEVIXX : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 11
!     VIX(13)    = EDEVIYY : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 22
!     VIX(14)    = EDEVIZZ : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 33
!     VIX(15)    = EDEVIXY : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 12
!     VIX(16)    = EdessXX : DEFORMATION DE FLUAGE DE DESSICCATION  11
!     VIX(17)    = EdessYY : DEFORMATION DE FLUAGE DE DESSICCATION  22
!     VIX(18)    = EdessZZ : DEFORMATION DE FLUAGE DE DESSICCATION  33
!     VIX(19)    = EdessXY : DEFORMATION DE FLUAGE DE DESSICCATION  12
!     VIX(20)    = EFXX    : DEFORMATION TOTALE DE FLUAGE PROPRE    11
!     VIX(21)    = EFYY    : DEFORMATION TOTALE DE FLUAGE PROPRE    22
!     VIX(22)    = EFZZ    : DEFORMATION TOTALE DE FLUAGE PROPRE    33
!     VIX(23)    = EFXY    : DEFORMATION TOTALE DE FLUAGE PROPRE    12
!
!     DANS LE CAS 3D :
!     VIX(1)     = ElasticStrainXX : DEFORMATION ELASTIQUE 11
!     VIX(2)     = ElasticStrainYY : DEFORMATION ELASTIQUE 22
!     VIX(3)     = ElasticStrainZZ : DEFORMATION ELASTIQUE 33
!     VIX(4)     = ElasticStrainXY : DEFORMATION ELASTIQUE 12
!     VIX(5)     = ElasticStrainXZ : DEFORMATION ELASTIQUE 13
!     VIX(6)     = ElasticStrainYZ : DEFORMATION ELASTIQUE 23
!     VIX(7)     = ESPHR   : DEFORMATION DE FLUAGE REV SPHERIQUE
!     VIX(8)     = ESPHI   : DEFORMATION DE FLUAGE IRR SPHERIQUE
!     VIX(9)     = ELIM    : DEF. EQUIVALENTE DU FP IRREVERSIBLE MAX
!     VIX(10)    = EDEVRXX : DEFORMATION DE FLUAGE REV DEVIATORIQUE 11
!     VIX(11)    = EDEVRYY : DEFORMATION DE FLUAGE REV DEVIATORIQUE 22
!     VIX(12)    = EDEVRZZ : DEFORMATION DE FLUAGE REV DEVIATORIQUE 33
!     VIX(13)    = EDEVRXY : DEFORMATION DE FLUAGE REV DEVIATORIQUE 12
!     VIX(14)    = EDEVRXZ : DEFORMATION DE FLUAGE REV DEVIATORIQUE 13
!     VIX(15)    = EDEVRYZ : DEFORMATION DE FLUAGE REV DEVIATORIQUE 23
!     VIX(16)    = EDEVIXX : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 11
!     VIX(17)    = EDEVIYY : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 22
!     VIX(18)    = EDEVIZZ : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 33
!     VIX(19)    = EDEVIXY : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 12
!     VIX(20)    = EDEVIXZ : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 13
!     VIX(21)    = EDEVIYZ : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 23
!     VIX(22)    = EdessXX : DEFORMATION DE FLUAGE DE DESSICCATION  11
!     VIX(23)    = EdessYY : DEFORMATION DE FLUAGE DE DESSICCATION  22
!     VIX(24)    = EdessZZ : DEFORMATION DE FLUAGE DE DESSICCATION  33
!     VIX(25)    = EdessXY : DEFORMATION DE FLUAGE DE DESSICCATION  12
!     VIX(26)    = EdessXZ : DEFORMATION DE FLUAGE DE DESSICCATION  13
!     VIX(27)    = EdessYZ : DEFORMATION DE FLUAGE DE DESSICCATION  23
!     VIX(28)    = EFXX    : DEFORMATION TOTALE DE FLUAGE PROPRE    11
!     VIX(29)    = EFYY    : DEFORMATION TOTALE DE FLUAGE PROPRE    22
!     VIX(30)    = EFZZ    : DEFORMATION TOTALE DE FLUAGE PROPRE    33
!     VIX(31)    = EFXY    : DEFORMATION TOTALE DE FLUAGE PROPRE    12
!     VIX(32)    = EFXZ    : DEFORMATION TOTALE DE FLUAGE PROPRE    13
!     VIX(33)    = EFYZ    : DEFORMATION TOTALE DE FLUAGE PROPRE    23
! ----------------------------------------------------------------------
    implicit none
    character(len=*) :: cmp
    real(kind=8) :: vim(33), epsfm(6)
    integer :: ndim, i
!
    if (cmp(1:2) .eq. 'FP') then
        do 20 i = 1, 3
            epsfm(i)=(vim(7)+vim(8))
20      continue
        if (ndim.eq.3) then
            epsfm(1)=epsfm(1)+vim(10)+vim(16)
            epsfm(2)=epsfm(2)+vim(11)+vim(17)
            epsfm(3)=epsfm(3)+vim(12)+vim(18)
            epsfm(4)=vim(13)+vim(19)
            epsfm(5)=vim(15)+vim(21)
            epsfm(6)=vim(14)+vim(20)
        else if (ndim.eq.2) then
            epsfm(1)=epsfm(1)+vim(8)+vim(12)
            epsfm(2)=epsfm(2)+vim(9)+vim(13)
            epsfm(3)=epsfm(3)+vim(10)+vim(14)
            epsfm(4)=vim(11)+vim(15)
            epsfm(5)=0.
            epsfm(6)=0.
        endif
    else if (cmp(1:2).eq.'FD') then
        if (ndim.eq.3) then
            epsfm(1)=vim(22)
            epsfm(2)=vim(23)
            epsfm(3)=vim(24)
            epsfm(4)=vim(25)
            epsfm(5)=vim(27)
            epsfm(6)=vim(26)
        else if (ndim.eq.2) then
            epsfm(1)=vim(16)
            epsfm(2)=vim(17)
            epsfm(3)=vim(18)
            epsfm(4)=vim(19)
            epsfm(5)=0.
            epsfm(6)=0.
        endif
    else if (cmp(1:2).eq.'FT') then
        do 25 i = 1, 3
            epsfm(i)=(vim(7)+vim(8))
25      continue
        if (ndim.eq.3) then
            epsfm(1)=epsfm(1)+vim(10)+vim(16)+vim(22)
            epsfm(2)=epsfm(2)+vim(11)+vim(17)+vim(23)
            epsfm(3)=epsfm(3)+vim(12)+vim(18)+vim(24)
            epsfm(4)=vim(13)+vim(19)+vim(25)
            epsfm(5)=vim(15)+vim(21)+vim(27)
            epsfm(6)=vim(14)+vim(20)+vim(26)
        else if (ndim.eq.2) then
            epsfm(1)=epsfm(1)+vim(8)+vim(12)+vim(16)
            epsfm(2)=epsfm(2)+vim(9)+vim(13)+vim(17)
            epsfm(3)=epsfm(3)+vim(10)+vim(14)+vim(18)
            epsfm(4)=vim(11)+vim(15)+vim(19)
            epsfm(5)=0.
            epsfm(6)=0.
        endif
    endif
!
end subroutine
