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

subroutine postsm(option, fm, df, sigm, sigp,&
                  dsidep)
!
!
    implicit none
#include "asterf_types.h"
#include "blas/dcopy.h"
#include "blas/dscal.h"
    character(len=16) :: option
    real(kind=8) :: fm(3, 3), df(3, 3), sigm(6), sigp(6), dsidep(6, 3, 3)
!
!------------------------------------------------------------
!   IN  OPTION : OPTION DEMANDEE : RIGI_MECA_TANG, FULL_MECA, RAPH_MECA
!   IN  FM : GRADIENT DE LA TRANSFORMATION EN T-
!   IN  DF : GRADIENT DE LA TRANSFORMATION DE T- A T+
!   IN  SIGM : CONTRAINTE EN T-
!   IN/OUT  SIGP : CONTRAINTE CAUCHY EN T+ -> CONTRAINTE KIRCHHOF EN T+
!   IN/OUT  DSIDEP : MATRICE TANGENTE D(SIG)/DF  ->
!                    D(TAU)/D(FD) * (FD)t
!-----------------------------------------------------------------------
    aster_logical :: resi, rigi
    integer :: kl, p, q, i
    real(kind=8) :: jm, dj, jp, tau(6), j, mat(6, 3, 3), id(3, 3), rc(6)
!
    data    id   /1.d0, 0.d0, 0.d0,&
     &              0.d0, 1.d0, 0.d0,&
     &              0.d0, 0.d0, 1.d0/
!   
    real(kind=8) :: rac2
    parameter    (rac2 = sqrt(2.d0))
    data    rc /1.d0, 1.d0, 1.d0, rac2, rac2, rac2/
!
!
    resi = option(1:4).eq.'RAPH' .or. option(1:4).eq.'FULL'
    rigi = option(1:4).eq.'RIGI' .or. option(1:4).eq.'FULL'
!
    jm=fm(1,1)*(fm(2,2)*fm(3,3)-fm(2,3)*fm(3,2))&
     &  -fm(2,1)*(fm(1,2)*fm(3,3)-fm(1,3)*fm(3,2))&
     &  +fm(3,1)*(fm(1,2)*fm(2,3)-fm(1,3)*fm(2,2))
!
    dj=df(1,1)*(df(2,2)*df(3,3)-df(2,3)*df(3,2))&
     &  -df(2,1)*(df(1,2)*df(3,3)-df(1,3)*df(3,2))&
     &  +df(3,1)*(df(1,2)*df(2,3)-df(1,3)*df(2,2))
!
    jp=jm*dj
!
    if (resi) then
        call dscal(6, jp, sigp, 1)
        call dcopy(6, sigp, 1, tau, 1)
        j = jp
    else
        call dcopy(6, sigm, 1, tau, 1)
        call dscal(6, jm, tau, 1)
        j = jm
    endif
!
!
    if (rigi) then
        call dcopy(54, dsidep, 1, mat, 1)
        call dscal(54, j, mat, 1)
        do 100 kl = 1, 6
            do 200 p = 1, 3
                do 300 q = 1, 3
                    dsidep(kl,p,q) = tau(kl)*id(p,q)
                    do 400 i = 1, 3
                        dsidep(kl,p,q) = dsidep(kl,p,q) + mat(kl,p,i)* df(q,i)
400                 continue
!
                        dsidep(kl,p,q) = dsidep(kl,p,q)*rc(kl)
!
300             continue
200         continue
100     continue
    endif
!
    call dscal(3, rac2, sigp(4), 1)
!
end subroutine
