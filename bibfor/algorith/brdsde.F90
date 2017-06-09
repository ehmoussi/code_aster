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

subroutine brdsde(e0, nu0, dsidep, vim, sigm)
!
!    ROUTINE ANCIENNEMENT NOMMEE DSIDEPRG
!
!
    implicit none
#include "asterfort/brchre.h"
#include "asterfort/brksec.h"
#include "asterfort/brvp33.h"
#include "asterfort/transp.h"
#include "asterfort/utbtab.h"
    real(kind=8) :: e0, nu0
    real(kind=8) :: vim(65), sigm(6)
    real(kind=8) :: dsidep(6, 6), h66(6, 6)
    real(kind=8) :: s33(3, 3), sn3(3)
    real(kind=8) :: x33(3, 3), vbt33(3, 3), vbt33t(3, 3)
    real(kind=8) :: bt33(3, 3), bc0, bt3(3), trav(3, 3)
    integer :: i
!
!
!      PRINT *,'JE PASSE DANS MAT TANG'
!       RANGEMENT DES ENDOMMAGEMENTS EN TABLEAU 3*3
!
    s33(1,1)=sigm(1)
    s33(2,2)=sigm(2)
    s33(3,3)=sigm(3)
    s33(1,2)=sigm(4)
    s33(1,3)=sigm(5)
    s33(2,3)=sigm(6)
    s33(2,1)=s33(1,2)
    s33(3,1)=s33(1,3)
    s33(3,2)=s33(2,3)
    bt33(1,1)=vim(58)
    bt33(2,2)=vim(59)
    bt33(3,3)=vim(60)
    bt33(1,2)=vim(61)
    bt33(1,3)=vim(62)
    bt33(2,3)=vim(63)
    bt33(2,1)=bt33(1,2)
    bt33(3,1)=bt33(1,3)
    bt33(3,2)=bt33(2,3)
    bc0=vim(64)
!
    call brvp33(bt33, bt3, vbt33)
    call transp(vbt33, 3, 3, 3, vbt33t,&
                3)
! PASSAGE DES CONTRAINTES DANS LA BASE PRINCIPALE D'ENDOMMAGEMENT
    call utbtab('ZERO', 3, 3, s33, vbt33,&
                trav, x33)
!
    do 10 i = 1, 3
        sn3(i)=s33(i,i)
10  end do
!
    call brksec(h66, bt3, bc0, nu0, e0,&
                sn3)
!
! PASSAGE H66 EN BASE FIXE
    call brchre(h66, vbt33t, vbt33, dsidep)
!      CALL AFFICHE66(DSIDEP)
!      DO I=1,6
!       DO J=1,6
!      PRINT*,'DSIDEP (',I,',',J,')',DSIDEP(I,J)
!       ENDDO
!       ENDDO
end subroutine
