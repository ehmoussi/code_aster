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

subroutine rvchn2(deplaz, nomjv, nbno, numnd, orig,&
                  axez)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisdg.h"
#include "asterfort/jedema.h"
#include "asterfort/jedupo.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/select_dof.h"
#include "asterfort/utmess.h"
#include "asterfort/utpvgl.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
    integer :: nbno, numnd(*)
    character(len=*) :: deplaz, nomjv
    real(kind=8) :: orig(3), axez(3)
!
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    integer :: ino
    integer :: iavald, nunoe, numdx, numdy, numdz, numdrx
    integer :: numdry, numdrz, i, nbNode, nbCmp
    real(kind=8) :: valed(3), vald(3), valer(3), valr(3), pscal
    real(kind=8) :: xnormr, epsi, axer(3), axet(3), pgl(3, 3)
    character(len=8) :: nomnoe, mesh
    character(len=8) :: gran_name
    character(len=19) :: depla
    integer, pointer :: tablCmp(:) => null()
    integer, pointer :: listNode(:) => null()
    character(len=8), pointer :: listCmp(:) => null()
    real(kind=8), pointer :: vale(:) => null()
!     ------------------------------------------------------------------
    call jemarq()
!
    depla = deplaz
    epsi = 1.0d-6
!
    call dismoi('NOM_GD', deplaz, 'CHAM_NO', repk=gran_name)
    call dismoi('NOM_MAILLA', deplaz, 'CHAM_NO', repk=mesh)
    if (gran_name .ne. 'DEPL_R') then
        call utmess('F', 'POSTRELE_17')
    endif
    call jeveuo(mesh//'.COORDO    .VALE', 'L', vr=vale)
!
! - Create list of components
!
    nbCmp = 6
    AS_ALLOCATE(vk8=listCmp, size = nbCmp)
    listCmp(1) = 'DX'
    listCmp(2) = 'DY'
    listCmp(3) = 'DZ'
    listCmp(4) = 'DRX'
    listCmp(5) = 'DRY'
    listCmp(6) = 'DRZ'
!
! - Create list of equations
!
    AS_ALLOCATE(vi=tablCmp, size = nbCmp)
!
! - Create list of equations
!
    nbNode = 1
    AS_ALLOCATE(vi=listNode, size = nbNode)
!
    call jedupo(depla//'.VALE', 'V', nomjv, .false._1)
    call jeveuo(nomjv, 'E', iavald)
!
    do ino = 1, nbno
!
        nunoe = numnd(ino)
!
        axer(1) = vale(1+3*(nunoe-1) ) - orig(1)
        axer(2) = vale(1+3*(nunoe-1)+1) - orig(2)
        axer(3) = vale(1+3*(nunoe-1)+2) - orig(3)
        pscal = axer(1)*axez(1)+axer(2)*axez(2)+axer(3)*axez(3)
        axer(1) = axer(1) - pscal*axez(1)
        axer(2) = axer(2) - pscal*axez(2)
        axer(3) = axer(3) - pscal*axez(3)
        xnormr = 0.0d0
        do i = 1, 3
            xnormr = xnormr + axer(i)*axer(i)
        end do
        if (xnormr .lt. epsi) then
            call jenuno(jexnum(mesh//'.NOMNOE', nunoe), nomnoe)
            call utmess('F', 'POSTRELE_30', sk=nomnoe)
        endif
        xnormr = sqrt( xnormr )
        do i = 1, 3
            axer(i) = axer(i) / xnormr
        end do
        axet(1) = axez(2)*axer(3) - axez(3)*axer(2)
        axet(2) = axez(3)*axer(1) - axez(1)*axer(3)
        axet(3) = axez(1)*axer(2) - axez(2)*axer(1)
        do i = 1, 3
            xnormr = xnormr + axet(i)*axet(i)
        end do
        xnormr = sqrt( xnormr )
        if (xnormr .lt. epsi) then
            call jenuno(jexnum(mesh//'.NOMNOE', nunoe), nomnoe)
            call utmess('F', 'POSTRELE_31', sk=nomnoe)
        endif
        do i = 1, 3
            pgl(1,i) = axer(i)
            pgl(2,i) = axez(i)
            pgl(3,i) = axet(i)
        end do
        listNode(1) = numnd(ino)
        tablCmp(1:nbCmp) = 0
        call select_dof(tablCmp_ = tablCmp,&
                        fieldNodeZ_ = depla,&
                        nbNodeToSelect_ = nbNode, listNodeToSelect_ = listNode,&
                        nbCmpToSelect_  = nbCmp , listCmpToSelect_  = listCmp)

        numdx  = tablCmp(1)
        numdy  = tablCmp(2)
        numdz  = tablCmp(3)
        numdrx = tablCmp(4)
        numdry = tablCmp(5)
        numdrz = tablCmp(6)
        valed(1) = 0.0d0
        valed(2) = 0.0d0
        valed(3) = 0.0d0
        valer(1) = 0.0d0
        valer(2) = 0.0d0
        valer(3) = 0.0d0
        if (numdx.ne.0) then
            valed(1) = zr(iavald-1+numdx)
        endif
        if (numdy.ne.0) then
            valed(2) = zr(iavald-1+numdy)
        endif
        if (numdz.ne.0) then
            valed(3) = zr(iavald-1+numdz)
        endif
        if (numdrx.ne.0) then
            valer(1) = zr(iavald-1+numdrx)
        endif
        if (numdry.ne.0) then
            valer(2) = zr(iavald-1+numdry)
        endif
        if (numdrz.ne.0) then
            valer(3) = zr(iavald-1+numdrz)
        endif
        if ((numdx+numdy+numdz) .ne. 0) then
            call utpvgl(1, 3, pgl, valed, vald)
            if (numdx .ne. 0) zr(iavald-1+numdx) = vald(1)
            if (numdy .ne. 0) zr(iavald-1+numdy) = vald(2)
            if (numdz .ne. 0) zr(iavald-1+numdz) = vald(3)
        endif
        if ((numdrx+numdry+numdrz) .ne. 0) then
            call utpvgl(1, 3, pgl, valer, valr)
            if (numdrx .ne. 0) zr(iavald-1+numdrx) = valr(1)
            if (numdry .ne. 0) zr(iavald-1+numdry) = valr(2)
            if (numdrz .ne. 0) zr(iavald-1+numdrz) = valr(3)
        endif
    end do
!
    AS_DEALLOCATE(vi=tablCmp)
    AS_DEALLOCATE(vi=listNode)
    AS_DEALLOCATE(vk8=listCmp)
!
    call jedema()
end subroutine
