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

subroutine granac(fami, kpg, ksp, icdmat, materi,&
                  compo, irrap, irram, tm, tp,&
                  depsgr)
!     RECUPERATION DES CARACTERISTIQUES DE GRANDISSEMENT
    implicit none
#include "asterfort/rcvalb.h"
#include "asterfort/assert.h"
    integer :: icdmat, kpg, ksp, nbpar, codret(1)
    real(kind=8) :: irram, irrap, tm, tp, valres(1),prec
    real(kind=8) :: depsgm, depsgp, depsgr, valpar(2)
    character(len=8) :: materi, nomgrd, nompar(2)
    character(len=16) :: compo
    character(len=*) :: fami
    data           nomgrd /'GRAN_FO'/
!
    prec = 0.000001d0
    depsgr = 0.0d0
    if (compo(1:13) .eq. 'GRAN_IRRA_LOG' .or. compo(1:13) .eq. 'LEMAITRE_IRRA') then
        if (abs(irrap-irram).gt.prec) then
            if (abs(tp-tm).gt.prec) then
!                write (6,*) 'tm,tp = ',tm,tp
!                write (6,*) 'irram,irrap = ',irram,irrap
                ASSERT(.false.)
            endif
            nbpar=2
            nompar(1)='TEMP'
            nompar(2)='IRRA'
    !
    !        INSTANT -
            valpar(1)=tm
            valpar(2)=irram
            if (irram .gt. 0.0d0) then
                call rcvalb(fami, kpg, ksp, '+', icdmat,&
                            materi, compo, nbpar, nompar, valpar,&
                            1, nomgrd, valres, codret, 0)
                depsgm = valres(1)
            else
                depsgm = 0.0d0
            endif
    !
    !        INSTANT +
            valpar(1)=tp
            valpar(2)=irrap
            if (irrap .gt. 0.0d0) then
                call rcvalb(fami, kpg, ksp, '+', icdmat,&
                            materi, compo, nbpar, nompar, valpar,&
                            1, nomgrd, valres, codret, 0)
                depsgp = valres(1)
            else
                depsgp = 0.0d0
            endif
    !
            depsgr = (depsgp - depsgm)/100.0d0
            if (depsgr .lt. 0.0d0) then
                depsgr = 0.0d0
            endif
        else 
            depsgr = 0.d0
        endif
    endif
end subroutine
