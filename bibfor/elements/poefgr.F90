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

subroutine poefgr(nomte, klc, mater, e, xnu, rho, effo)
!
!
!
! --------------------------------------------------------------------------------------------------
!
!     CALCUL DU VECTEUR ELEMENTAIRE EFFORT GENERALISE REEL,
!     POUR LES ELEMENTS DE POUTRE D'EULER ET DE TIMOSHENKO.
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
!
    integer :: mater
    character(len=*) :: nomte
    real(kind=8) :: klc(12,12), e, xnu, rho, effo(*)
!
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/lonele.h"
#include "asterfort/matrot.h"
#include "asterfort/pmavec.h"
#include "asterfort/pmfmas.h"
#include "asterfort/pomass.h"
#include "asterfort/poutre_modloc.h"
#include "asterfort/ptforp.h"
#include "asterfort/utmess.h"
#include "asterfort/utpvgl.h"
#include "asterfort/vecma.h"
#include "asterfort/verifm.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, iret, itype, j, jdepl, kanl, ldyna
    integer :: lmater, lopt, lorien
    integer :: nc, ncc, nno, nnoc
    real(kind=8) :: a, a2, xl, ethm
    real(kind=8) :: ul(12), fe(12), mlv(78), mlc(12, 12), fei(12)
    real(kind=8) :: pgl(3, 3)
    character(len=24) :: suropt
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_cara = 3
    real(kind=8) :: vale_cara(nb_cara)
    character(len=8), parameter :: noms_cara(nb_cara) = (/'A1  ','A2  ','TVAR'/)
!
! --------------------------------------------------------------------------------------------------
!
    nno = 2
    nc  = 6
    nnoc = 1
    ncc  = 6
!   recuperation des caracteristiques generales des sections
    call poutre_modloc('CAGNPO', noms_cara, nb_cara, lvaleur=vale_cara)
    a   = vale_cara(1)
    a2  = vale_cara(2)
    itype = nint(vale_cara(3))
!
!   recuperation des coordonnees des noeuds ---
    xl = lonele()
!
!   matrice de rotation pgl
    call jevech('PCAORIE', 'L', lorien)
    call matrot(zr(lorien), pgl)
!
!   vecteur deplacement local
    call jevech('PDEPLAR', 'L', jdepl)
    call utpvgl(nno, nc, pgl, zr(jdepl), ul)
!
!   vecteur effort local  effo = klc * ul
    call pmavec('ZERO', 12, klc, ul, effo)
!
!   tenir compte des efforts dus a la dilatation
    call verifm('NOEU', nno, 1, '+', mater, ethm, iret)
!
    if (ethm .ne. 0.d0) then
        ul(1:12) = 0.d0
!
        ul(1) = -ethm*xl
        ul(7) = -ul(1)
!       calcul des forces induites
        do i = 1, 6
            do j = 1, 6
                effo(i)   = effo(i)   - klc(i,j)*ul(j)
                effo(i+6) = effo(i+6) - klc(i+6,j+6)*ul(j+6)
            enddo
        enddo
    endif
!
!   tenir compte des efforts repartis/pesanteur
    call ptforp(itype, 'CHAR_MECA_PESA_R', nomte, a, a2, xl, 0, nno, nc, pgl, fe, fei)
    do i = 1, 12
        effo(i) = effo(i) - fe(i)
    enddo
!
    call ptforp(itype, 'CHAR_MECA_FR1D1D', nomte, a, a2, xl, 0, nno, nc, pgl, fe, fei)
    do i = 1, 12
        effo(i) = effo(i) - fe(i)
    enddo
!
    call ptforp(itype, 'CHAR_MECA_FF1D1D', nomte, a, a2, xl, 0, nno, nc, pgl, fe, fei)
    do i = 1, 12
        effo(i) = effo(i) - fe(i)
    enddo
!
!   force dynamique
    kanl = 2
    call jevech('PSUROPT', 'L', lopt)
    suropt = zk24(lopt)
    if (suropt(1:4) .eq. 'MASS') then
        if (suropt .eq. 'MASS_MECA_DIAG' .or. suropt .eq. 'MASS_MECA_EXPLI') kanl = 0
        if (suropt .eq. 'MASS_MECA     ') kanl = 1
        if (suropt .eq. 'MASS_FLUI_STRU') kanl = 1
        if (kanl .eq. 2) then
            call utmess('A', 'ELEMENTS2_44', sk=suropt)
        endif
        if (nomte.eq.'MECA_POU_D_EM') then
            call jevech('PMATERC', 'L', lmater)
            call pmfmas(nomte, ' ', 0.d0, zi(lmater), kanl, mlv)
        else
            call pomass(nomte, e, xnu, rho, kanl, mlv)
        endif
        call vecma(mlv, 78, mlc, 12)
        call jevech('PCHDYNR', 'L', ldyna)
        call utpvgl(nno, nc, pgl, zr(ldyna), ul)
        call pmavec('ZERO', 12, mlc, ul, fe)
        do i = 1, 12
            effo(i) = effo(i) + fe(i)
        enddo
    endif
!
end subroutine
