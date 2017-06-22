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

subroutine mbrigi(fami, kpg, imate, rig)
!
! ----------------------------------------------------------------------
!      CALCUL DE LA MATRICE DE RIGIDITE POUR UN COMPORTEMENT
!                   DE MEMBRANE ANISOTROPE
! ----------------------------------------------------------------------
! IN  FAMI         FAMILLE D'ELEMENT
! IN  KPG          NUMERO DU POINT DE GAUSS
! IN  IMATE        IDENTIFIANT DU MATERIAU
! OUT RIG          MATRICE DE RIGIDITE MEMBRANAIRE
! ----------------------------------------------------------------------
!
    implicit none
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/r8inir.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
    integer :: codres(7)
    character(len=4) :: fami
    character(len=16) :: nomres(7)
    character(len=32) :: phenom
    integer :: kpg, imate, codret
    real(kind=8) :: valres(7), rig(3, 3)
!
! - VERIFICATION DU COMPORTEMENT
!
    call rccoma(zi(imate), 'ELAS', 1, phenom, codret)
    if (phenom .ne. 'ELAS_MEMBRANE') then
        call utmess('F', 'MEMBRANE_5')
    endif
!
! - RECUPERATION DES COMPOSANTES
!
    nomres(1) = 'M_LLLL'
    nomres(2) = 'M_LLTT'
    nomres(3) = 'M_LLLT'
    nomres(4) = 'M_TTTT'
    nomres(5) = 'M_TTLT'
    nomres(6) = 'M_LTLT'
!
    call rcvalb(fami, kpg, 1, '+', zi(imate),&
                ' ', phenom, 0, ' ', [0.d0],&
                6, nomres, valres, codres, 1)
!
! -  EN CAS DE PROBLEME AVEC LES VARIABLES DE COMMANDES
!
!      CALL RCVALA(ZI(IMATE),' ',PHENOM,
!     &            0,' ',0.D0,6,
!     &            NOMRES,VALRES,CODRES, 1)
!
! - CONSTRUCTION DE LA MATRICE DE RIGIDITE
!
    call r8inir(3*3, 0.d0, rig, 1)
    rig(1,1) = valres(1)
    rig(2,1) = valres(2)
    rig(3,1) = valres(3)
    rig(1,2) = valres(2)
    rig(2,2) = valres(4)
    rig(3,2) = valres(5)
    rig(1,3) = valres(3)
    rig(2,3) = valres(5)
    rig(3,3) = valres(6)
!
end subroutine
