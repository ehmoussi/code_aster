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

subroutine cfatmu(neq, nbliac, sdcont_solv)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/calatm.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
!
    integer :: neq
    integer :: nbliac
    character(len=24) :: sdcont_solv
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE DISCRETE - ALGORITHME)
!
! CALCUL DE ATMU - VECTEUR DES FORCES DE CONTACT
!
!
! ----------------------------------------------------------------------
!
! IN  NEQ    : NOMBRE D'EQUATIONS
! IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
!                'E': RESOCO(1:14)//'.ATMU'
!
!
!
    integer :: iliac, lliac, jdecal, compts
    integer :: nbddl, kk
    character(len=19) :: liac, mu, atmu
    integer :: jliac, jmu, jatmu
    character(len=24) :: appoin, apddl, apcoef
    integer :: japptr, japddl, japcoe
!
    call jemarq()
!
    liac = sdcont_solv(1:14)//'.LIAC'
    mu = sdcont_solv(1:14)//'.MU'
    atmu = sdcont_solv(1:14)//'.ATMU'
    appoin = sdcont_solv(1:14)//'.APPOIN'
    apddl = sdcont_solv(1:14)//'.APDDL'
    apcoef = sdcont_solv(1:14)//'.APCOEF'
    call jeveuo(liac, 'L', jliac)
    call jeveuo(mu, 'L', jmu)
    call jeveuo(appoin, 'L', japptr)
    call jeveuo(apddl, 'L', japddl)
    call jeveuo(apcoef, 'L', japcoe)
    call jeveuo(atmu, 'E', jatmu)
    compts = 0
!
    do kk = 1, neq
        zr(jatmu+kk-1) = 0.0d0
    end do
    do iliac = 1, nbliac 
        lliac = zi(jliac +iliac-1)
        jdecal = zi(japptr+lliac-1)
        nbddl = zi(japptr+lliac ) - zi(japptr+lliac-1)
        compts = compts + 1
        call calatm(neq, nbddl, zr(jmu-1+compts), zr(japcoe+jdecal), zi( japddl+jdecal),&
                    zr(jatmu))
    end do
!
    call jedema()
!
end subroutine
