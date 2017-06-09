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

subroutine xfem_count_ddl(neq, deeq, k8cmp, nbnomax, ino_xfem, is_xfem, &
                              nbnoxfem, ieq_loc, neq_mloc, maxi_ddl)
!
!-----------------------------------------------------------------------
! BUT : 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!  CALCUL DE 2 INFOS
!   * NEQ_MLOC :: LE NOMBRE TOTAL DE DDL A CONSIDERER POUR UN NOUED XFEM DONNE
!   * IEQ_LOC :: LA POSITION LOCALE D UN DDL (IF IEQ_LOC(NUNO)<> 0 <=> DDL MARQUE)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!
!-----------------------------------------------------------------------
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/xfem_cmps.h"
!-----------------------------------------------------------------------
!
    character(len=8) :: k8cmp(*)
    integer :: deeq(*), neq, nbnomax, nbnoxfem, maxi_ddl
    integer :: ino_xfem(nbnomax)
    integer :: ieq_loc(neq), neq_mloc(nbnoxfem)
    aster_logical :: is_xfem(nbnomax)
!
!-----------------------------------------------------------------------
!
    character(len=8) :: nocmp
    integer :: ieq, nuno, nucmp, j
    integer :: ipos
    integer :: ddlmax
    parameter (ddlmax=52)
!
!   REMARQUE: ON A AU PLUS 27 DDLS POUR UN ELEMENT XFEM (cf. 3D_XHHC)
!-----------------------------------------------------------------------
!
    call jemarq()
!
    do 20 ieq = 1, neq
       nuno=deeq(2*(ieq-1)+1)
       nucmp=deeq(2*(ieq-1)+2)
       nocmp=k8cmp(nucmp)
!       write(6,*) ieq,'|', nuno,'|', nocmp
       if(nuno .lt. 1) goto 20
       if(.not. is_xfem(nuno)) goto 20
       if(.not. xfem_cmps(nocmp,'OUI')) goto 20
       ipos=neq_mloc(ino_xfem(nuno))+1
       ieq_loc(ieq)=ipos
       neq_mloc(ino_xfem(nuno))=ipos
 20  continue
!
    maxi_ddl=0
    do j=1,nbnoxfem
       maxi_ddl=max(neq_mloc(j),maxi_ddl)
    enddo
!
    ASSERT(maxi_ddl .le. ddlmax)
!
    call jedema()
!
end subroutine
