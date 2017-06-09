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

subroutine dtmprep_noli_yacs(sd_dtm_, sd_nl_, icomp)
    use yacsnl_module , only:  add_trandata
    implicit none
! dtmprep_noli_yacs : prepare the calculations for a localized nonlinearity
!                     introduced using another code (ex. lubrication code). 
!                     The communication is ensured by YACS.
!                     This routine adds one or more 
!                     occurences to sd_nl and increments NB_NOLI in sd_dtm
!
!             icomp : an integer giving the index of occurence of the 
!                     nonlinearity to be treated under the factor kw
!                     COMPORTEMENT of the command DYNA_VIBRA.
!person_in_charge: mohamed-amine.hassini at edf.fr



#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvis.h"
#include "asterfort/gettco.h"
#include "asterfort/assert.h"
#include "asterfort/nlget.h"
#include "asterfort/nlsav.h"
#include "asterfort/dtmget.h"
#include "asterfort/dtmsav.h"
#include "asterfort/posddl.h"
#include "asterfort/dismoi.h"
#include "asterfort/nlinivec.h"
#include "asterfort/utnono.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asteryacs.h"


!   -0.1- Input/output arguments
    character(len=*) , intent(in) :: sd_dtm_
    character(len=*) , intent(in) :: sd_nl_
    integer          , intent(in) :: icomp

!   -0.2  Variables locales
    
    integer            :: inod, gno, mxlevel, ilevel
    integer            :: i, j, iret
    integer            :: ncmp , neq
    integer            :: nbmode, nn1
    character(len=8)   :: sd_dtm, sd_nl, mesh
    character(len=8)   :: nomno, chamno, nume
    character(len=16)  :: typnum
    character(len=24)  :: grnom
    real(kind=8), pointer       :: bmodal_v(:)       => null()
    real(kind=8), pointer       :: defmod(:)         => null()
    character(len=8), pointer   :: lcmp(:) => null()
    integer, pointer            :: iddl(:)  => null()
    character(len=24)  :: port_name

    integer, save :: num = 0



#define motfac 'COMPORTEMENT'
#define bmodal(m,n) bmodal_v((n-1)*neq+m)


      call jemarq()

!      print *, "We are preparing data"

  
      sd_dtm = sd_dtm_
      sd_nl = sd_nl_

   
      ! data are stored at position i
      call nlget(sd_nl, _MAX_LEVEL, iscal=mxlevel)
      ilevel = mxlevel + 1


!   --- 1 - Basic information about the mesh and numbering 
!
      call dtmget(sd_dtm, _NUM_DDL, kscal=nume)
      call dtmget(sd_dtm, _NB_MODES, iscal=nbmode)
      call gettco(nume, typnum)


!   --- 1.1 - Case with a simple modal projection (direct calculation)
      if (typnum(1:16) .eq. 'NUME_DDL_SDASTER') then
        call dismoi('NOM_MAILLA' , nume , 'NUME_DDL' , repk=mesh)
        call nlsav(sd_nl, _NUMDDL_1, 1, iocc=ilevel, kscal=nume(1:8))
        call nlsav(sd_nl, _MESH_1, 1, iocc=ilevel, kscal=mesh)
      else
        ! case not handled
        ASSERT(.false.)
      end if
!

!   --- 2 - Retrieving data

      !only one node for the moment
      call getvtx(motfac, 'NOEUD', iocc=icomp, scal=nomno, nbret=inod)
      call getvtx(motfac, 'GROUP_NO', iocc=icomp, scal=grnom, nbret=gno)

      ASSERT(inod.gt.0 .or. gno.gt.0)

      if( gno .gt. 0)then
        call utnono(' ', mesh, 'NOEUD', grnom, nomno, iret)
        ASSERT(iret .eq. 0)
      endif

      call nlsav(sd_nl, _NO1_NAME, 1, iocc=ilevel, kscal=nomno)

      !type of field "DEPL, VITE, FORCE"
      call getvtx(motfac, 'TYPE_CHAM', iocc=icomp, scal=chamno, nbret=inod)

      !call nlsav(sd_nl, _YACS_CHAM, 1, iocc=ilevel, kscal = chamno )



      !list of components ('DX', 'DY', 'DZ', 'DRX', 'DRY','DRZ')
      call getvtx(motfac, 'NOM_CMP', iocc=icomp, nbval=0, nbret=inod)
      if(inod.lt.0) then
        ncmp=-inod
        AS_ALLOCATE(vk8=lcmp, size=ncmp)
        AS_ALLOCATE( vi = iddl, size= ncmp )
        call getvtx(motfac, 'NOM_CMP', iocc=icomp, nbval=ncmp, vect=lcmp, nbret=inod)
        do j=1, ncmp
           call posddl('NUME_DDL', nume, nomno, lcmp(j), nn1, iddl(j) )
        end do
        AS_DEALLOCATE(vk8=lcmp)
      else
         ! it is mandatory to give at least one component
         ASSERT(.false.)
      endif

      !retrieve the name of port
      call getvtx(motfac, 'PORT_YACS', iocc=icomp, scal = port_name, nbret = inod)

!-----------------------


!       -- 3.7 - Modal displacements of the node(s)
      call dtmget(sd_dtm, _BASE_VEC, vr=bmodal_v)
      call dtmget(sd_dtm, _NB_PHYEQ, iscal=neq)

      call nlinivec(sd_nl, _MODAL_DEPL_NO1, ncmp*nbmode, iocc=ilevel, vr=defmod)

      !call posddl('NUME_DDL', nume, nomno, cmpno, nn1, nddl1)
      !print *, "position ddl", nddl1

    
    ! stockage de la deformee modale
      do j = 1, nbmode
          do i=1, ncmp
             defmod(ncmp*(j-1)+i) = bmodal(iddl(i), j)
          end do
      enddo

     call nlsav(sd_nl, _NL_TYPE , 1, iocc=ilevel, iscal= NL_YACS)
     call nlsav(sd_nl, _NL_TITLE, 1, iocc=ilevel, kscal="NLYACS")


!   --- 4 - Updating indices for sd_nl and sd_dtm

      call nlsav(sd_nl, _MAX_LEVEL, 1, iscal=ilevel)
      call dtmsav(sd_dtm, _NB_NONLI, 1, iscal=ilevel)


      ! create specified ports

!      print *, "creating tran_data: ", port_name

      num = num + 1

      call add_trandata( num, trim(port_name), chamno, iddl, defmod )

!      print *, "fin de prep_yacs"

      AS_DEALLOCATE(vi = iddl)
!      
      call jedema()


end subroutine
