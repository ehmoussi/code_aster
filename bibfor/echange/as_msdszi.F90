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

subroutine as_msdszi(fid,mname,jname,numdt,numit,it,letype,lgtype,&
                     retype,rgtype,ncor,cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_config.h"
#include "asterf_types.h"
#include "med/msdszi.h"
    med_idt :: fid
    character(len=*) :: mname,jname
    aster_int :: numdt,numit,it,letype,lgtype,retype,rgtype,ncor,cret

#ifdef _DISABLE_MED
    call u2mess('F', 'FERMETUR_2')
#else

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdszi fid=',fid
    write(6,*) '=== as_msdszi mname=',mname
    write(6,*) '=== as_msdszi jname=',jname
    write(6,*) '=== as_msdszi numdt=',numdt
    write(6,*) '=== as_msdszi numit=',numit
    write(6,*) '=== as_msdszi it=',it
#endif

#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fid4
    med_int :: numdt4,numit4,it4,letype4,lgtype4,&
               retype4,rgtype4,ncor4,cret4
    fid4=to_med_idt(fid)
    numdt4=to_med_int(numdt)
    numit4=to_med_int(numit)
    it4=to_med_int(it)

    call msdszi(fid4,mname,jname,numdt4,numit4,it4,letype4,&
                lgtype4,retype4,rgtype4,ncor4,cret4)

    letype=to_aster_int(letype4)
    lgtype=to_aster_int(lgtype4)
    retype=to_aster_int(retype4)
    ncor=to_aster_int(ncor4)
    cret=to_aster_int(cret4)

#else
    call msdszi(fid,mname,jname,numdt,numit,it,letype,lgtype,&
                retype,rgtype,ncor,cret)
#endif

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdszi letype=',letype
    write(6,*) '=== as_msdszi lgtype=',lgtype
    write(6,*) '=== as_msdszi retype=',retype
    write(6,*) '=== as_msdszi ncor=',ncor
    write(6,*) '=== as_msdszi cret=',cret
#endif

#endif
end subroutine
