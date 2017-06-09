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

subroutine xdelt3(ndim, ksi, tabls, delta)
    implicit none
!
#    include "jeveux.h"
#    include "asterfort/jedema.h"
#    include "asterfort/jemarq.h"
#    include "asterfort/elrfdf.h"
#    include "asterfort/elrfvf.h"
    integer :: ndim
    real(kind=8) :: tabls(3), ksi(ndim), delta
!                 CALCUL DE LA QUANTITE A MINIMISER POUR LE CALCUL
!                    DES COORDONNEES DU POINT D'INTERSECTION
!
!     ENTREE
!       NDIM    : DIMENSION TOPOLOGIQUE DU MAILLAGE
!       KSI     : COORDONNEES DE REFERENCE DU POINT
!       LSNL    : VALEUR DES LSN DES NOEUDS DE L'ARETE
!
!     SORTIE
!       DELTA   : QUANTITE A MINIMISER
!     ----------------------------------------------------------------
!
!
    real(kind=8) :: ff(3), dff(3, 3)
    integer :: i, nderiv, nno
    real(kind=8) :: fctg, dfctg
!
!
!......................................................................
!
! --- CALCUL DES FONCTIONS DE FORME ET DE LEUR DERIVEES EN UN POINT
! --- DANS LA MAILLE
!
!
!   
    call jemarq()
    fctg = 0.d0
    dfctg = 0.d0
!
!
!     CALCUL DES FONCTIONS DE FORME DE L'ELEMENT EN KSI
    call elrfvf('SE3', ksi, 3, ff, nno)
!
!     CALCUL DES DERIVEES FONCTIONS DE FORME DE L'ELEMENT EN KSI
    call elrfdf('SE3', ksi, ndim*nno, dff, nno,&
                nderiv)
!
!
! --- CALCUL DE FCTG,D1FCTG,D2FCTG EN KSI
! ---           FCTG : LEVEL SET NORMALE
    do 105 i = 1, nno
        fctg = fctg + ff(i)*tabls(i)
        dfctg=dfctg+tabls(i)*dff(1,i)
105  continue
!
! --- CALCUL DES QUANTITES A MINIMISER
!     CALCUL DE DELTAS
!
    delta=fctg/dfctg
!
    call jedema()
end subroutine
