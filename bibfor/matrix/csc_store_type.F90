! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

module csc_store_type 
!
implicit none 
private 
#include "asterf_types.h"
#include "asterfort/assert.h"
!

type dyn_column 
  ! indices lignes des termes de la colonne
  integer(kind=4), dimension(:), pointer :: rowind 
  ! valeurs des termes non-nuls de la colonne
  real(kind=8), dimension(:), pointer :: values 
  ! nombre de termes non-nuls dans la colonne
  integer :: nnz 
end type dyn_column 
!
type, public :: csc_store
   integer :: ncol 
   integer :: nnz 
   type(dyn_column), dimension(:), pointer :: pcol
   real(kind=8), dimension(:), pointer     :: rwork 
   integer(kind=4), dimension(:), pointer  :: iwork 
   aster_logical, dimension(:), pointer    :: is_nz
end type csc_store 
!
public :: create_csc_store, put_to_csc_store, free_csc_store
!
contains 
!
subroutine new_dyn_column( dc )
   ! 
   type (dyn_column), intent(out) :: dc
   nullify(dc%rowind)
   nullify(dc%values)
   dc%nnz=0
   !
end subroutine new_dyn_column 
subroutine free_dyn_column( dc )
   ! 
   type (dyn_column), intent(inout) :: dc
   if ( dc%nnz > 0 ) then 
   if (associated( dc%rowind )) then 
     deallocate(dc%rowind)
   endif
   if (associated( dc%values )) then 
     deallocate(dc%values)
   endif 
   endif 
   !
end subroutine free_dyn_column 
!
subroutine new_csc_store( cs  )
  type( csc_store ), intent(out) :: cs
  !
  nullify(cs%pcol)
  cs%nnz=0
  nullify(cs%rwork)
  nullify(cs%iwork)
  !
end subroutine new_csc_store
!
! nwork : taille des tableaux de travail rwork et iwork qui stockent 
! le vecteur avant compression
subroutine create_csc_store( ncol, cs, nwork )
  integer, intent(in) :: ncol, nwork
  type(csc_store), intent(out) :: cs 
  !
  integer :: ii 
  !
  call new_csc_store( cs ) 
  cs%ncol = ncol 
  allocate( cs%pcol(ncol) )
  do ii=1, ncol
     call new_dyn_column( cs%pcol(ii) ) 
  enddo
  allocate(cs%rwork(nwork))
  allocate(cs%iwork(nwork))
  allocate(cs%is_nz(nwork))
  !  
end subroutine create_csc_store 
!
subroutine free_csc_store( cs ) 
  type(csc_store), intent(inout) :: cs 
  !
   integer :: ii 
  !
  do ii=1, cs%ncol
     call free_dyn_column( cs%pcol(ii) ) 
  enddo
  deallocate( cs%pcol )
  deallocate( cs%rwork )
  deallocate( cs%iwork ) 
  deallocate( cs%is_nz )
end subroutine free_csc_store

subroutine create_dyn_column( nnz, dc )
  integer, intent(in) :: nnz
  type(dyn_column), intent(out) :: dc
  !
  !
  if (nnz /= 0 ) then 
     allocate( dc%rowind( nnz ) )
     allocate( dc%values( nnz ) )
  endif 
  dc%nnz=nnz
  !
end subroutine create_dyn_column 
!
! Compress and store nv vectors in cs
! v(:,k) <-> column jcol(k) in cs 
subroutine put_to_csc_store( v, ldv, nv, jcol,  cs )
integer, dimension(:), intent(in)      :: jcol
integer, intent(in)                    :: ldv, nv
real(kind=8), dimension(:), intent(in) :: v
type(csc_store), intent(inout)         :: cs 
!
integer :: ii, kk, nnz, off, pass 
!
do kk = 1, nv 
do pass = 1, 2
   ASSERT( jcol(kk)> 0 )
   nnz = 0 
   off = ldv*(kk-1)
   do ii = 1, ldv
      if ( abs(v(off+ii)) > 0.d0 ) then 
          nnz = nnz +1 
          if ( pass == 2 ) then 
             cs%pcol(jcol(kk))%values(nnz) = v(off+ii)
             cs%pcol(jcol(kk))%rowind(nnz) = int(ii,4)
             cs%nnz = cs%nnz + nnz 
          endif 
      endif 
   enddo
   if ( pass == 1 ) then 
      call create_dyn_column( nnz, cs%pcol(jcol(kk)) )
   endif 
enddo
enddo 
!
end subroutine put_to_csc_store

end module 
