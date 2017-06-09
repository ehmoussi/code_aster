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

subroutine rcfon2(quest, jprol, jvale, nbvale, sigy,&
                  e, nu, p, rp, rprim,&
                  c, sieleq, dp)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
!
    character(len=1), intent(in) :: quest
    integer, intent(in) :: jprol
    integer, intent(in) :: jvale
    integer, intent(in) :: nbvale
    real(kind=8), optional, intent(in) :: sieleq
    real(kind=8), optional, intent(in) :: e
    real(kind=8), optional, intent(in) :: nu
    real(kind=8), optional, intent(in) :: p
    real(kind=8), optional, intent(out) :: sigy
    real(kind=8), optional, intent(out) :: rp
    real(kind=8), optional, intent(out) :: rprim
    real(kind=8), optional, intent(in) :: c
    real(kind=8), optional, intent(out) :: dp
!
! --------------------------------------------------------------------------------------------------
!
! Comportment - Utility
!
! Get information by interpolation on traction curve R(p) - Prager version
!
! --------------------------------------------------------------------------------------------------
!
! In  Quest   : type of information to get
!               'S' - Elastic yield
!               'V' - R(p), dR(p), A[R(p),p]
!               'E' - R(p), dR(p)/dp, dp, A[R(p),p]
! In  jprol   : adress of .PROL object for R(p) function
! In  jvale   : adress of .VALE object for R(p) function
! In  nbvale  : number of values in R(p) function
! Out sigy    : elastic yield
! In  e       : Young modulus
! In  nu      : Poisson coefficient
! In  sieleq  : elastic stress
! In  p       : internal variable (plastic strain)
! In  c       : Prager constant
! Out rp      : value of R(p)
! Out rprim   : value of dR(p)/dp at p
! Out dp      : cumulutated plastic strain
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: tessup
    character(len=1) :: type_prol
    character(len=24) :: func_name
    integer :: jp, jr, i, i0
    real(kind=8) :: p0, rp0, pp, equ, deuxmu, rpm
!
! --------------------------------------------------------------------------------------------------
!
    jp = jvale
    jr = jvale + nbvale
    type_prol = zk24(jprol+4)(2:2)
    func_name = zk24(jprol+5)
!
! - Elastic yield
!
    if (quest .eq. 'S') then
        sigy = zr(jr)
        goto 999
    endif
!
! - Check
!
    if (p .lt. 0) then
        call utmess('F', 'COMPOR5_59')
    endif
    tessup = .false.
!
! - PARCOURS JUSQU'A P
    do i = 1, nbvale-1
        if (p .lt. zr(jp+i)) then
            i0 = i-1
            goto 20
        endif
    end do
    tessup = .true.
    if (type_prol .eq. 'E') then
        call utmess('F', 'COMPOR5_60', sk=func_name, sr=p)
    endif
    i0=nbvale-1
 20 continue
!
! - CALCUL DES VALEURS DE R(P), R'(P) ET AIRE(P)
!
    if (quest .eq. 'V') then
        if (tessup) then
            if (type_prol .eq. 'L') then
                rprim = (zr(jr+i0)-zr(jr+i0-1))/ (zr(jp+i0)-zr(jp+i0- 1))
            else
                rprim = 0.d0
            endif
        else
            rprim = (zr(jr+i0+1)-zr(jr+i0))/ (zr(jp+i0+1)-zr(jp+i0))
        endif
!
        p0 = zr(jp+i0)
        rp0 = zr(jr+i0)
        rp = rp0 + rprim*(p-p0) - 1.5d0*c*p
        rprim = rprim - 1.5d0*c
        goto 999
    endif
!
! - RESOLUTION DE L'EQUATION R(P+DP) + 3/2*(2MU+C) DP = SIELEQ
!
    deuxmu = e/(1+nu)
    do i = i0+1, nbvale-1
        equ = zr(jr+i) + 1.5d0*(deuxmu+c)*(zr(jp+i)-p) - sieleq
        if (equ .gt. 0) then
            i0 = i-1
            goto 40
        endif
    end do
    tessup = .true.
    if (type_prol .eq. 'E') then
        call utmess('F', 'COMPOR5_60', sk=func_name, sr=p)
    endif
    i0 = nbvale-1
 40 continue
!
! - CALCUL DES VALEURS DE DP, R(P+DP), R'(P+DP)
!
    if (tessup) then
        if (type_prol .eq. 'L') then
            rprim = (zr(jr+i0)-zr(jr+i0-1))/ (zr(jp+i0)-zr(jp+i0-1))
        else
            rprim = 0.d0
        endif
    else
        rprim = (zr(jr+i0+1)-zr(jr+i0))/ (zr(jp+i0+1)-zr(jp+i0))
    endif
!
    p0 = zr(jp+i0)
    rp0 = zr(jr+i0)
    rpm = rp0+rprim*(p-p0) -1.5d0*c*p
    dp = (sieleq-rpm)/(1.5d0*deuxmu+rprim)
    pp = p+dp
    rp = rp0 + rprim*(pp-p0)-1.5d0*c*pp
    rprim = rprim - 1.5d0*c
!
999 continue
end subroutine
