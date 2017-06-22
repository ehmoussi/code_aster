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

subroutine cafmes(ifa, cont, tange, maxfa, nface,&
                  fkss, dfks1, dfks2, mobfas, dmob1,&
                  dmob2, dmob1f, dmob2f, fmw, fm1w,&
                  fm2w)
!  CETTE SUBROUTINE PERMET DE CALCULER D UNE MANIERE GENERIQUE LE FLUX
!  MASSIQUE
!=======================================================================
! ****IN :
!     IFA              : ARETE EXTERNE QUE L ON CONSIDERE DANS ASSESU
!     FKSS             : FLUX SUR L ARETE EXTERNE
!                             QUE L ON CONSIDERE DS ASSESU
!     DFKS1(1,IFA)     : DERIVEE DE FKS(IFA) % A LA PREMIERE
!                                              INCONNUE AU CENTRE
!     DFKS1(JFA+1,IFA) : DERIVEE DE FKS(IFA) % A LA PREMIERE
!                                              INCONNUE FACE
!     DFKS2(1,IFA)     : DERIVEE DE FKS(IFA) % A LA DEUXIEME
!                                              INCONNUE AU CENTRE
!     DFKS2(JFA+1,IFA) : DERIVEE DE FKS(IFA) % A LA DEUXIEME
!                                              INCONNUE FACE
!     MOBFAS           : MOBILITE SUR L ARETE EXTERNE QUE L ON
!                                              CONSIDERE DS ASSESU
!     DMOB1            : DERIVEE DE MOBFAS % A LA PREMIERE
!                                              VARIABLE AU CENTRE
!     DMOB2            : DERIVEE DE MOBFAS % A LA SECONDE
!                                              VARIABLE AU CENTRE
!     DMOB1F           : DERIVEE DE MOBFAS % A LA PREMIERE
!                                              VARIABLE A L ARETE
!     DMOB2F           : DERIVEE DE MOBFAS % A LA SECONDE
!                                              VARIABLE A L ARETE
!
! ****IN-OUT :
!     FMW              : FLUX MASSIQUE
!     FM1W             : DERIVEE DU FLUX % A LA PREMIERE VARIABLE
!     FM2W             : DERIVEE DU FLUX % A LA SECONDE VARIABLE
! ================================================
!     FMW =  MOB * F_{K,SIGMA}
!================================================
    implicit none
#include "asterf_types.h"
    aster_logical :: cont, tange
    integer :: maxfa
    integer :: nface
    real(kind=8) :: fmw(1:maxfa)
    real(kind=8) :: fkss
    real(kind=8) :: mobfas
    real(kind=8) :: dmob1(1:maxfa), dmob2(1:maxfa), dmob1f(1:maxfa)
    real(kind=8) :: dmob2f(1:maxfa)
    real(kind=8) :: fm1w(1+maxfa, maxfa), fm2w(1+maxfa, maxfa)
    real(kind=8) :: dfks1(1+maxfa, maxfa), dfks2(1+maxfa, maxfa)
    integer :: ifa, jfa
!
    if (cont) then
        fmw(ifa) = fmw(ifa)+ mobfas * fkss
    endif
    if (tange) then
        fm1w(1,ifa) = fm1w(1,ifa) + dmob1(ifa) * fkss + mobfas * dfks1(1,ifa)
!
        fm2w(1,ifa) = fm2w(1,ifa) + dmob2(ifa) * fkss + mobfas * dfks2(1,ifa)
        do 4 jfa = 2, nface+1
            fm1w(jfa,ifa)= fm1w(jfa,ifa) + mobfas * dfks1(jfa,ifa)
            fm2w(jfa,ifa)= fm2w(jfa,ifa) + mobfas * dfks2(jfa,ifa)
  4     continue
        fm1w(1+ifa,ifa)= fm1w(1+ifa,ifa) + dmob1f(ifa) * fkss
        fm2w(1+ifa,ifa)= fm2w(1+ifa,ifa) + dmob2f(ifa) * fkss
    endif
end subroutine
