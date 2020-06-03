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

subroutine dbg_base()
    implicit none
!
! person_in_charge: mathieu.courtois@edf.fr
!
! Check that the splitting of the results databases works as expected.
!
! This subroutine is only used by unittest and enabled using:
!   DEBUT(DEBUG=_F(VERI_BASE='OUI'))
!
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jelibe.h"
#include "asterfort/wkvect.h"
!
    aster_logical :: exist
    integer, parameter :: n = 5
    integer :: lfic(n), mfic
    common /fenvje/  lfic, mfic
!
    character(len=2) :: dn2
    character(len=5) :: classe
    character(len=8) :: nomfic, kstout, kstini
    common /kficje/  classe    , nomfic(n) , kstout(n) , kstini(n) ,&
     &                 dn2(n)
!
    integer :: nblmax, nbluti, longbl, kitlec, kitecr, kiadm, iitlec, iitecr
    integer :: nitecr, kmarq
    common /ificje/  nblmax(n) , nbluti(n) , longbl(n) ,&
     &               kitlec(n) , kitecr(n) ,             kiadm(n) ,&
     &               iitlec(n) , iitecr(n) , nitecr(n) , kmarq(n)
!
    character(len=19) :: objname
    integer :: dbsize, recsize, recint, recavail
    integer :: nbrec, objint, nbobj, ic, i, total
    integer :: jadr
!
    ic = index(classe, 'V')
    ASSERT(ic .ne. 0)
    ! dbsize = mfic * 1024
    ! recint = 100 * 1024
    ! recsize = 8 * recint
    ! nbrec = dbsize / recsize
    ! objint = recint / 16
    ! nbobj = 16 + 8
    recint = longbl(ic) * 1024
    recsize = 8 * recint
    nbrec = nblmax(ic)
    dbsize = recsize * nbrec
    objint = recint / 4
    nbobj = 4 * nbrec + 8
    print *, "--- Check for the extensions of out of core database ---"
    print *, "Database size         :", dbsize, "kB"
    print *, "Record size           :", recsize, "kB"
    print *, "Record size           :", recint, "integers"
    print *, "Number of records     :", nbrec
    print *, "Object size           :", objint, "integers"
    print *, "Max. number of objects:", nbobj
    print *, "Allocated size        :", nbobj * objint * 8, "kB"
    print *, "Allocated size        :", nbobj * objint, "integers"

    inquire(file='vola.1', exist=exist)
    ASSERT(exist)
    inquire(file='vola.2', exist=exist)
    ASSERT(.not. exist)

!   The creation of an additional database should occur before the 16th object
!   because of the system objects.
    i = 0
    total = 0
    do while (i < nbobj .and. .not. exist)
        i = i + 1
        write(objname, '(A12,I7)') '&&VERI_BASE.', i
        total = total + objint
        call wkvect(objname, 'V V I', objint, jadr)
        call jelibe(objname)
        inquire(file='vola.2', exist=exist)
        print *, "Object created", objname, " exist ? ", exist, total
    end do

!   TEST_RESU
    inquire(file='vola.2', exist=exist)
    if (exist) then
        write(6,*) "  OK  "
    else
        write(6,*) " NOOK "
    endif
end subroutine
