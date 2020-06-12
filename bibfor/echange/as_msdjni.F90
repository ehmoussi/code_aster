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

subroutine as_msdjni(fid,lmname,ind,jname,des,dom,rmname,nstep,ncor,cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_config.h"
#include "asterf_types.h"
#include "asterfort/utmess.h"
#include "med/msdjni.h"
    character(len=*) :: lmname,jname,des,rmname
    med_idt :: fid
    aster_int :: ind,dom,nstep,ncor,cret

#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdjni fid=',fid
    write(6,*) '=== as_msdjni lmname=',lmname
    write(6,*) '=== as_msdjni ind=',ind
#endif

#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fid4
    med_int :: ind4,dom4,nstep4,ncor4,cret4
    fid4=to_med_idt(fid)
    ind4=to_med_int(ind)
    call msdjni(fid4,lmname,ind4,jname,des,dom4,rmname,nstep4,ncor4,cret4)
    dom=to_aster_int(dom4)
    nstep=to_aster_int(nstep4)
    ncor =to_aster_int(ncor4)
    cret =to_aster_int(cret4)
#else
    call msdjni(fid,lmname,ind,jname,des,dom,rmname,nstep,ncor,cret)
#endif

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdjni jname=',jname
    write(6,*) '=== as_msdjni rmname=',rmname
    write(6,*) '=== as_msdjni des=',des
    write(6,*) '=== as_msdjni dom=',dom
    write(6,*) '=== as_msdjni nstep=',nstep
    write(6,*) '=== as_msdjni ncor=',ncor
    write(6,*) '=== as_msdjni cret=',cret
#endif

#endif
end subroutine
