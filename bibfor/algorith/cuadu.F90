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

subroutine cuadu(deficu, resocu, neq, nbliac)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/caladu.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: neq
    integer :: nbliac
    character(len=24) :: deficu
    character(len=24) :: resocu
!
! ----------------------------------------------------------------------
! ROUTINE APPELEE PAR : ALGOCU
! ----------------------------------------------------------------------
!
!  ROUTINE MERE POUR LE CALCUL DU SECOND MEMBRE
!
! IN  DEFICU : SD DE DEFINITION (ISSUE D'AFFE_CHAR_MECA)
! IN  RESOCU : SD DE TRAITEMENT NUMERIQUE DU CONTACT
!                'E': RESOCU(1:14)//'.MU'
! IN  NEQ    : NOMBRE D'EQUATIONS
! IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
!
!
!
!
    integer :: iliac, nbddl
    integer :: lliac, jdecal
    real(kind=8) :: val
    character(len=19) :: liac, mu, delt0
    integer :: jliac, jmu, jdelt0
    character(len=24) :: apddl, apcoef, apjeu, poinoe
    integer :: japddl, japcoe, japjeu, jpoi
! ======================================================================
    call jemarq()
! ======================================================================
    apddl = resocu(1:14)//'.APDDL'
    liac = resocu(1:14)//'.LIAC'
    apcoef = resocu(1:14)//'.APCOEF'
    apjeu = resocu(1:14)//'.APJEU'
    mu = resocu(1:14)//'.MU'
    delt0 = resocu(1:14)//'.DEL0'
    poinoe = deficu(1:16)//'.POINOE'
! ======================================================================
    call jeveuo(apddl, 'L', japddl)
    call jeveuo(liac, 'L', jliac)
    call jeveuo(apcoef, 'L', japcoe)
    call jeveuo(apjeu, 'L', japjeu)
    call jeveuo(delt0, 'L', jdelt0)
    call jeveuo(mu, 'E', jmu)
    call jeveuo(poinoe, 'L', jpoi)
! ======================================================================
    do 10 iliac = 1, nbliac
        lliac = zi(jliac-1+iliac)
        jdecal = zi(jpoi+lliac-1)
        nbddl = zi(jpoi+lliac) - zi(jpoi+lliac-1)
        call caladu(neq, nbddl, zr(japcoe+jdecal), zi(japddl+jdecal), zr( jdelt0),&
                    val)
        zr(jmu+iliac-1) = zr(japjeu+lliac-1) - val
10  continue
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
