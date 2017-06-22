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

subroutine mmctan(nommai, alias, nno, ndim, coorma,&
                  coorno, itemax, epsmax, tau1, tau2)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mmnewt.h"
#include "asterfort/utmess.h"
    character(len=8) :: nommai, alias
    integer :: itemax, ndim, nno
    real(kind=8) :: epsmax, coorno(3), coorma(27)
    real(kind=8) :: tau1(3), tau2(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE APPARIEMENT (UTILITAIRE)
!
! CALCUL DES TANGENTES EN UN NOEUD D'UNE MAILLE
!
! ----------------------------------------------------------------------
!
!
! IN  NOMMAI : NOM DE LA MAILLE
! IN  ALIAS  : TYPE DE LA MAILLE
! IN  NNO    : NOMBRE DE NOEUDS DE LA MAILLE
! IN  NDIM   : DIMENSION DE LA MAILLE
! IN  COORMA : CORDONNNES DE LA MAILLE
! IN  COORNO : COORODNNEES DU NOEUD
! IN  ITEMAX : NOMBRE MAXI D'ITERATIONS DE NEWTON POUR LA PROJECTION
! IN  EPSMAX : RESIDU POUR CONVERGENCE DE NEWTON POUR LA PROJECTION
! OUT TAU1   : PREMIERE TANGENTE (NON NORMALISEE)
! OUT TAU2   : SECONDE TANGENTE (NON NORMALISEE)
!
!
!
!
!
    integer :: ifm, niv
    integer :: niverr
    real(kind=8) :: ksi1, ksi2
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('APPARIEMENT', ifm, niv)
!
! --- INITIALISATIONS
!
    niverr = 0
!
! --- CALCUL DES VECTEURS TANGENTS DE LA MAILLE EN CE NOEUD
!
    call mmnewt(alias, nno, ndim, coorma, coorno,&
                itemax, epsmax, ksi1, ksi2, tau1,&
                tau2, niverr)
!
! --- GESTION DES ERREURS LORS DU NEWTON LOCAL POUR LA PROJECTION
!
    if (niverr .eq. 1) then
        call utmess('F', 'APPARIEMENT_13', sk=nommai, nr=3, valr=coorno)
    endif
!
    call jedema()
end subroutine
