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

subroutine dxroep(rho, epais)
    implicit none
#include "jeveux.h"
#include "asterc/r8maem.h"
#include "asterfort/jevech.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvala.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
    real(kind=8) :: rho, epais
!
!     APPEL DES MASSE VOLUMIQUE DU MATERIAU ET EPAISSEUR DE LA PLAQUE
!     ------------------------------------------------------------------
    integer :: jmate, nbv, jcoqu, iadzi, iazk24
    real(kind=8) :: r8bid, valres(2)
    integer :: icodre(2)
    character(len=24) :: valk(2)
    character(len=8) :: nomail
    character(len=16) :: nomres(2)
    character(len=32) :: phenom
! --DEB
!
    r8bid = 0.d0
    call jevech('PMATERC', 'L', jmate)
!
    call rccoma(zi(jmate), 'ELAS', 1, phenom, icodre(1))
!
    if (phenom .eq. 'ELAS_COQMU') then
        nomres(1) = 'HOM_19'
        nomres(2) = 'HOM_20'
        nbv = 2
        call rcvala(zi(jmate), ' ', phenom, 0, ' ', [r8bid], nbv, nomres, valres, icodre, 1)
        epais = valres(1)
        rho = valres(2)
        if (rho .eq. r8maem()) then
            call tecael(iadzi, iazk24)
            nomail = zk24(iazk24-1+3)(1:8)
            valk (1) = 'RHO'
            valk (2) = nomail
            call utmess('F', 'ELEMENTS4_81', nk=2, valk=valk)
        endif
!
    elseif (phenom .eq. 'ELAS'      .or. phenom .eq. 'ELAS_COQUE' .or.&
            phenom .eq. 'ELAS_ISTR' .or. phenom .eq. 'ELAS_ORTH'  .or.&
            phenom .eq. 'ELAS_GLRC' .or. phenom .eq. 'ELAS_DHRC') then
        nomres(1) = 'RHO'
        nbv = 1
        call rcvala(zi(jmate), ' ', phenom, 0, ' ', [r8bid], nbv, nomres, valres, icodre, 1)
        rho = valres(1)
        call jevech('PCACOQU', 'L', jcoqu)
        epais = zr(jcoqu)
!
    else
        call utmess('F', 'ELEMENTS_50')
    endif
!
end subroutine
