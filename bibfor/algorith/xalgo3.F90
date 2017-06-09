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

subroutine xalgo3(ndim, elrefp, nnop, it, nnose, cnset, typma, ndime,&
                  geom, lsnelp, pmilie, ninter, ainter, ar, npts, nptm, &
                  pmmax, nmilie, mfis, lonref, pinref, pintt, pmitt, jonc, exit)
    implicit none
!
#    include "jeveux.h"
#    include "asterfort/assert.h"
#    include "asterfort/xalg30.h"
#    include "asterfort/xalg31.h"
#    include "asterfort/xalg40.h"
#    include "asterfort/xalg41.h"
#    include "asterfort/xalg42.h"
#    include "asterfort/xalg20.h"
    character(len=8) :: typma, elrefp
    integer ::  ndim, ndime, nnop, it, nnose, cnset(*), exit(2)
    integer ::  ninter, pmmax, npts, nptm, nmilie, mfis, ar(12, 3)
    real(kind=8) :: lonref, ainter(*), pmilie(*), lsnelp(27)
    real(kind=8) :: pinref(*), pintt(*), pmitt(*), geom(81)
    aster_logical :: jonc
!            BUT :  TROUVER LES PTS MILIEUX DANS L ELEMENT COUPE EN 3D
!
!     ENTREE
!       NDIM     : DIMENSION DE L ELEMENT
!       TYPMA    : TYPE DE MAILLE
!       TABCO    : COORDONNES DES NOEUDS DE LE ELEMENT PARENT
!       PINTER   : COORDONNES DES POINTS D INTERSECTION
!       PMILIE   : COORDONNES DES POINTS MILIEUX
!       NINTER   : NOMBRE DE POINTS D INTERSECTION
!       AINTER   : INFOS ARETE ASSOCIÉE AU POINTS D'INTERSECTION
!       AR       : CONNECTIVITE DU TETRA
!       PMMAX    : NOMBRE DE POINTS MILIEUX MAXIMAL DETECTABLE
!       NPTS     : NB DE PTS D'INTERSECTION COINCIDANT AVEC UN NOEUD SOMMET
!       LSNELP   : LSN AUX NOEUDS DE L'ELEMENT PARENT POUR LA FISSURE COURANTE
!       PINTT    : COORDONNEES REELLES DES POINTS D'INTERSECTION
!       PMITT    : COORDONNEES REELLES DES POINTS MILIEUX
!       JONC     : L'ELEMENT PARENT EST-IL TRAVERSE PAR PLUSIEURS FISSURES
!
!     SORTIE
!       NMILIE   : NOMBRE DE POINTS MILIEUX
!       PMILIE   : COORDONNES DES POINS MILIEUX
!     ----------------------------------------------------------------
!
!
    if (ndime .eq. 2) then
        call xalg20(ndim, elrefp, it, nnose, cnset, typma, ndime,&
                      geom, lsnelp, pmilie, ninter, ainter, ar, npts, nptm,&
                      pmmax, nmilie, mfis, lonref, pinref, pintt, pmitt, jonc, exit)
    else if (ninter .eq. 3 .and. npts .eq. 0) then
         call xalg30(ndim, elrefp, it, nnose, cnset, typma, ndime,&
                      geom, lsnelp, pmilie, ninter, ainter, ar, npts, nptm,&
                      pmmax, nmilie, mfis, lonref, pinref, pintt, pmitt, jonc, exit)
    else if (ninter .eq. 3 .and. npts .eq. 1) then
         call xalg31(ndim, elrefp, it, nnose, cnset, typma, ndime,&
                      geom, lsnelp, pmilie, ninter, ainter, ar, npts, nptm,&
                      pmmax, nmilie, mfis, lonref, pinref, pintt, pmitt, jonc, exit)
    else if (ninter .eq. 4 .and. npts.eq. 0) then
         call xalg40(ndim, elrefp, nnop, it, nnose, cnset, typma, ndime,&
                      geom, lsnelp, pmilie, ninter, ainter, ar, npts, nptm,&
                      pmmax, nmilie, mfis, lonref, pinref, pintt, pmitt, jonc, exit)
    else if (ninter .eq. 4 .and. npts.eq. 2) then
        call xalg42(ndim, elrefp, it, nnose, cnset, typma, ndime,&
                      geom, lsnelp, pmilie, ninter, ainter, ar, npts, nptm,&
                      pmmax, nmilie, mfis, lonref, pinref, pintt, pmitt, jonc, exit)
    else if (ninter .eq. 4 .and. npts.eq. 1) then
        call xalg41(ndim, elrefp, nnop, it, nnose, cnset, typma, ndime,&
                      geom, lsnelp, pmilie, ninter, ainter, ar, npts, nptm,&
                      pmmax, nmilie, mfis, lonref, pinref, pintt, pmitt, jonc, exit)
    else
        ASSERT(.false.)
    endif
!
end subroutine
