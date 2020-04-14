! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
subroutine te0160(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/biline.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/jevete.h"
#include "asterfort/matvec.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
#include "asterfort/verift.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/get_value_mode_local.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: CABLE
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer ::          icodre(2)
    real(kind=8) ::     valres(2)
    character(len=16) :: nomres(2)
    integer :: nno, kp, ii, jj, imatuu
    integer :: ipoids, ivf, igeom, imate, icoret
    integer :: icompo, idepla, ideplp, idfdk, imat, iyty, ivectu, ivarip
    integer :: jgano, kk, icontp, ndim, nelyty, nnos, nordre, npg
    real(kind=8) :: aire, coef, coef1, coef2
    real(kind=8), parameter :: demi = 0.5d0
    real(kind=8) :: etraction, epsth, ecompress, ecable
    real(kind=8) :: green, jacobi, nx, ytywpq(9), w(9)
    real(kind=8) :: preten
    character(len=16) :: defo_comp, rela_comp
    aster_logical :: lVect, lMatr, lVari, lSigm
    integer :: codret, iret
    real(kind=8) :: valr(2)
    character(len=8), parameter :: valp(2) = (/'SECT', 'TENS'/)
!
! --------------------------------------------------------------------------------------------------
!
    icontp = 1
    ivarip = 1
    imatuu = 1
    ivectu = 1
    codret = 0
!
! - Get element parameters
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
        npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfdk,jgano=jgano)
    call jevete('&INEL.CABPOU.YTY', 'L', iyty)
!   3 efforts par noeud
    nordre = 3*nno
!
! - Get input fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PDEPLMR', 'L', idepla)
    call jevech('PDEPLPR', 'L', ideplp)
    call jevech('PCOMPOR', 'L', icompo)
!
! - Properties of behaviour
!
    rela_comp = zk16(icompo-1+RELA_NAME)
    defo_comp = zk16(icompo-1+DEFO)
    if (rela_comp(1:5) .ne. 'CABLE') then
        call utmess('F', 'ELEMENTS3_37', sk = rela_comp)
    endif
    if (defo_comp .ne. 'GROT_GDEP') then
        call utmess('F', 'ELEMENTS3_38', sk = defo_comp)
    endif
!
! - Get material properties
!
    nomres(1) = 'E'
    nomres(2) = 'EC_SUR_E'
    call rcvalb('RIGI', 1, 1, '+', zi(imate),&
                ' ', 'ELAS', 0, '  ', [0.d0],&
                1, nomres, valres, icodre, 1)
    call rcvalb('RIGI', 1, 1, '+', zi(imate),&
                ' ', 'CABLE', 0, '  ', [0.d0],&
                1, nomres(2), valres(2), icodre(2), 1)
    etraction = valres(1)
    ecompress = etraction*valres(2)
    ecable    = etraction
!
! - Get section properties
!
    call get_value_mode_local('PCACABL', valp, valr, iret)
    ASSERT(iret .eq. 0)
    aire    = valr(1)
    preten  = valr(2)
!
! - Select objects to construct from option name
!
    call behaviourOption(option, zk16(icompo),&
                         lMatr , lVect ,&
                         lVari , lSigm ,&
                         codret)
!
! - Get output fields
!
    if (lMatr) then
        call jevech('PMATUUR', 'E', imatuu)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
    endif
!
! - Update displacements
!
    do ii = 1, 3*nno
        w(ii) = zr(idepla-1+ii) + zr(ideplp-1+ii)
    enddo
!
! - Loop on Gauss points
!
    do kp = 1, npg
        call verift('RIGI', kp, 1, '+', zi(imate),epsth_=epsth)
        kk = (kp-1)*nordre*nordre
        jacobi = sqrt(biline(nordre,zr(igeom),zr(iyty+kk),zr(igeom)))
        green = biline(nordre, w, zr(iyty+kk), zr(igeom))+ demi*biline( nordre, w, zr(iyty+kk), w)
        green = green/jacobi**2
        nx = etraction*aire*(green-epsth)
        if (abs(nx) .lt. 1.d-6) then
            nx = preten
        endif
!       le cable a un module plus faible en compression qu'en traction
!       le module de compression peut meme etre nul.
        if (nx .lt. 0.d0) then
            nx = nx*ecompress/etraction
            ecable = ecompress
        endif
!
        coef1 = ecable*aire*zr(ipoids-1+kp)/jacobi**3
        coef2 = nx*zr(ipoids-1+kp)/jacobi
        call matvec(nordre, zr(iyty+kk), 2, zr(igeom), w, ytywpq)
        if (lMatr) then
            nelyty = iyty - 1 - nordre + kk
            imat = imatuu - 1
            do ii = 1, nordre
                nelyty = nelyty + nordre
                do jj = 1, ii
                    imat = imat + 1
                    zr(imat) = zr(imat) + coef1*ytywpq(ii)*ytywpq(jj) + coef2*zr(nelyty+jj)
                enddo
            enddo
        endif
        if (lVect) then
            coef = nx*zr(ipoids-1+kp)/jacobi
            do ii = 1, nordre
                zr(ivectu-1+ii) = zr(ivectu-1+ii) + coef*ytywpq(ii)
            enddo
        endif
        if (lSigm) then
            zr(icontp-1+kp) = nx
        endif
        if (lVari) then
            zr(ivarip+kp-1) = 0.d0
        endif
    enddo
!
! - Save return code
!
    if (lSigm) then
        call jevech('PCODRET', 'E', icoret)
        zi(icoret) = codret
    endif
end subroutine
