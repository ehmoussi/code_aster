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
!
subroutine lcegeo(nno, npg, jv_poids, jv_func, jv_dfunc,&
                  geom, typmod, jvariexte, ndim,&
                  deplm, ddepl)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/isdeco.h"
#include "asterfort/calcExternalStateVariable1.h"
#include "asterfort/calcExternalStateVariable2.h"
#include "asterfort/calcExternalStateVariable3.h"
#include "asterfort/calcExternalStateVariable4.h"
!
integer, intent(in) :: nno, npg, ndim
integer, intent(in) :: jv_poids, jv_func, jv_dfunc
character(len=8), intent(in) :: typmod(2)
real(kind=8), intent(in) :: geom(3, nno)
real(kind=8), intent(in) :: deplm(3, nno), ddepl(3, nno)
integer, intent(in) :: jvariexte
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! Compute intrinsic external state variables
!
! --------------------------------------------------------------------------------------------------
!
! IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  NPG    : NOMBRE DE POINTS DE GAUSS
! IN  IPOIDS : POIDS DES POINTS DE GAUSS
! IN  IVF    : VALEUR  DES FONCTIONS DE FORME
! IN  IDFDE  : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! IN  GEOM   : COORDONEES DES NOEUDS
! IN  TYPMOD : TYPE DE MODELISATION
! In  jvariexte        : coded integer for external state variable
! OUT ELGEOM  : TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES AUX LOIS
!               DE COMPORTEMENT (DIMENSION MAXIMALE FIXEE EN DUR, EN
!               FONCTION DU NOMBRE MAXIMAL DE POINT DE GAUSS)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: tabcod(30), variextecode(1)
!
! --------------------------------------------------------------------------------------------------
!
    tabcod(:) = 0
    variextecode(1) = jvariexte
    call isdeco(variextecode(1), tabcod, 30)
!
! - Element size 1
!
    if (tabcod(ELTSIZE1) .eq. 1) then
        call calcExternalStateVariable1(nno     , npg    , &
                                        jv_poids, jv_func, jv_dfunc,&
                                        geom    , typmod )
    endif
!
! - Coordinates of Gauss points
!
    if (tabcod(COORGA) .eq. 1) then
        call calcExternalStateVariable2(nno    , npg   , ndim  ,&
                                        jv_func, &
                                        geom   , typmod)
    endif
!
! - Gradient of velocity
!
    if (tabcod(GRADVELO) .eq. 1) then
        call calcExternalStateVariable3(nno     , npg    , ndim    ,&
                                        jv_poids, jv_func, jv_dfunc,&
                                        geom    , deplm  , ddepl   )
    endif
!
! - Element size 2
!
    if (tabcod(ELTSIZE2) .eq. 1) then
        call calcExternalStateVariable4(nno     , npg   ,&
                                        jv_dfunc,&
                                        geom    , typmod)
    endif
!
end subroutine
