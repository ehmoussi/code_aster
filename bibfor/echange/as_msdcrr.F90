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

subroutine as_msdcrr(fid,lmname,jname,numdt,numit,entlcl,&
                     geolcl,entdst,geodst,ncorr,corrtab,cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_config.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/conv_int.h"
#include "med/msdcrr.h"
    character(len=*) :: lmname,jname
    med_idt :: fid
    aster_int :: numdt,numit,entlcl,geolcl,entdst
    aster_int :: geodst,ncorr,corrtab(*),cret

#ifdef _DISABLE_MED
    call u2mess('F', 'FERMETUR_2')
#else

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdcrr fid=',fid
    write(6,*) '=== as_msdcrr lmname=',lmname
    write(6,*) '=== as_msdcrr jname=',jname
    write(6,*) '=== as_msdcrr numdt=',numdt
    write(6,*) '=== as_msdcrr numit=',numit
    write(6,*) '=== as_msdcrr entlcl=',entlcl
    write(6,*) '=== as_msdcrr geolcl=',geolcl
    write(6,*) '=== as_msdcrr entdst=',entdst
    write(6,*) '=== as_msdcrr geodst=',geodst
    write(6,*) '=== as_msdcrr ncorr=',ncorr
#endif

#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fid4
    med_int :: numdt4,numit4,entlcl4,geolcl4,entdst4,geodst4,cret4
    med_int, allocatable :: corrtab4(:)
    fid4=to_med_idt(fid)
    numdt4 =to_med_int(numdt)
    numit4 =to_med_int(numit)
    entlcl4=to_med_int(entlcl)
    geolcl4=to_med_int(geolcl)
    entdst4=to_med_int(entdst)
    geodst4=to_med_int(geodst)
    ASSERT(ncorr.gt.0)
    allocate (corrtab4(ncorr))

    call msdcrr(fid4,lmname,jname,numdt4,numit4,entlcl4,&
                geolcl4,entdst4,geodst4,corrtab4,cret4)

    call conv_int('med->ast', ncorr, vi_ast=corrtab, vi_med=corrtab4)
    deallocate (corrtab4)
    cret=to_aster_int(cret4)

#else
    call msdcrr(fid,lmname,jname,numdt,numit,entlcl,&
                geolcl,entdst,geodst,corrtab,cret)
#endif

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdcrr corrtab(1:min(3,ncorr))=',corrtab(1:min(3,ncorr))
    write(6,*) '=== as_msdcrr cret=',cret
#endif

#endif
end subroutine
