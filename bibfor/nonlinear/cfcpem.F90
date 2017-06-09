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

subroutine cfcpem(resoco, nbliai)
!
!
    implicit     none
#include "jeveux.h"
!
#include "asterc/r8prem.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jelibe.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/r8inir.h"
#include "blas/daxpy.h"
    character(len=24) :: resoco
    integer :: nbliai
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (RESOLUTION - PENALISATION)
!
! CALCUL DE LA MATRICE DE CONTACT PENALISEE ELEMENTAIRE [E_N*AT]
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  NBLIAI : NOMBRE DE LIAISONS DE CONTACT
!
!
!
!
    integer :: ndlmax
    parameter   (ndlmax = 30)
    real(kind=8) :: jeuini
    real(kind=8) :: coefpn, xmu
    integer :: iliai
    character(len=24) :: apcoef, appoin
    integer :: japcoe, japptr
    character(len=24) :: tacfin
    integer :: jtacf
    character(len=24) :: jeux
    integer :: jjeux
    character(len=24) :: enat
    integer :: jenat
    integer :: ztacf
    integer :: nbddl, jdecal
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    appoin = resoco(1:14)//'.APPOIN'
    apcoef = resoco(1:14)//'.APCOEF'
    jeux = resoco(1:14)//'.JEUX'
    tacfin = resoco(1:14)//'.TACFIN'
    enat = resoco(1:14)//'.ENAT'
    call jeveuo(appoin, 'L', japptr)
    call jeveuo(apcoef, 'L', japcoe)
    call jeveuo(jeux, 'L', jjeux)
    call jeveuo(tacfin, 'L', jtacf)
    ztacf = cfmmvd('ZTACF')
!
! --- CALCUL DE LA MATRICE DE CONTACT PENALISEE
!
    do 210 iliai = 1, nbliai
        jdecal = zi(japptr+iliai-1)
        nbddl = zi(japptr+iliai) - zi(japptr+iliai-1)
        jeuini = zr(jjeux+3*(iliai-1)+1-1)
        coefpn = zr(jtacf+ztacf*(iliai-1)+1)
        call jeveuo(jexnum(enat, iliai), 'E', jenat)
        call r8inir(ndlmax, 0.d0, zr(jenat), 1)
        if (jeuini .lt. r8prem()) then
            xmu = sqrt(coefpn)
            call daxpy(nbddl, xmu, zr(japcoe+jdecal), 1, zr(jenat),&
                       1)
        endif
        call jelibe(jexnum(enat, iliai))
210  end do
!
    call jedema()
!
end subroutine
