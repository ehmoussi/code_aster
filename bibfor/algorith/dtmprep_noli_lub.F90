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

subroutine dtmprep_noli_lub(sd_dtm_, sd_nl_, icomp)
    use lub_module, only : add_bearing
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
#include "asterfort/getvr8.h"
#include "asterfort/gettco.h"
#include "asterfort/assert.h"
#include "asterfort/nlget.h"
#include "asterfort/nlsav.h"
#include "asterfort/dtmget.h"
#include "asterfort/dtmsav.h"
#include "asterfort/posddl.h"
#include "asterfort/dismoi.h"
#include "asterfort/nlinivec.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"


!   -0.1- Input/output arguments
    character(len=*) , intent(in) :: sd_dtm_
    character(len=*) , intent(in) :: sd_nl_
    integer          , intent(in) :: icomp

!   -0.2  Variables locales
    
    integer            :: inod, mxlevel, ilevel
    integer            :: i, j
    integer            :: ncmp , neq
    integer            :: nbmode, nn1
    character(len=8)   :: sd_dtm, sd_nl, mesh
    character(len=8)   :: nomno, nume, typ_palier
    character(len=16)  :: typnum
    real(kind=8), pointer       :: bmodal_v(:)       => null()
    real(kind=8), pointer       :: defmod(:)         => null()
    !character(len=8), pointer   :: lcmp(:) => null()
    integer, pointer            :: iddl(:)  => null()
    real(kind=8)       :: omega, dtedyo
    integer,  save     :: nbpal = 0



#define motfac 'COMPORTEMENT'
#define bmodal(m,n) bmodal_v((n-1)*neq+m)


      call jemarq()

!      print *, "preparing data"
  
      sd_dtm = sd_dtm_
      sd_nl = sd_nl_

   
      ! data are stored at position i
      call nlget(sd_nl, _MAX_LEVEL, iscal=mxlevel)
      ilevel = mxlevel + 1

      !call nlget (sd_nl, _NB_PALIE, iscal=nbpal)
      nbpal = nbpal + 1
      !call nlsav (sd_nl, _NUM_PALIER, 1, iocc=ilevel, iscal = nbpal)

      ! we are fixing the number of bearings to 20
      ! pretty much sure that it is more than enough !
      if(nbpal .gt. 20 ) then
         call utmess('F', 'EDYOS_43')
      end if


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
      call nlsav(sd_nl, _NO1_NAME, 1, iocc=ilevel, kscal=nomno)

!--   

      !print *, "retrieve component..."

      ! two components DX and DY
      ncmp = 2 
      AS_ALLOCATE( vi = iddl, size= ncmp )
      !call nlinivec(sd_nl, _YACS_IDDL, ncmp , iocc=ilevel, vi=iddl)
      call posddl('NUME_DDL', nume, nomno, 'DX      ', nn1, iddl(1))
      call posddl('NUME_DDL', nume, nomno, 'DY      ', nn1, iddl(2))



!--   retrieve the type of bearing ( old legacy ! not the right way to do it )

      call getvtx(motfac, 'TYPE_EDYOS', iocc= icomp, scal = typ_palier, nbret = inod)


!--   extracting the modal basis corresponding to the degrees of freedom


      call dtmget(sd_dtm, _BASE_VEC, vr=bmodal_v)
      call dtmget(sd_dtm, _NB_PHYEQ, iscal=neq)
      call nlinivec(sd_nl, _MODAL_DEPL_NO1, ncmp*nbmode, iocc=ilevel, vr=defmod)

    
    ! stockage de la deformee modale
      do j = 1, nbmode
          do i=1, ncmp
             defmod(ncmp*(j-1)+i) = bmodal(iddl(i), j)
          end do
      enddo


!--   storing some useful informations

      call nlsav(sd_nl, _NL_TYPE , 1, iocc=ilevel, iscal= NL_LUBRICATION)
      call nlsav(sd_nl, _NL_TITLE, 1, iocc=ilevel, kscal="NL_LUB")

!--   now we create the necessary ports for yacs communications

      call dtmget(sd_dtm, _V_ROT, rscal=omega)
      call getvr8(motfac, 'PAS_STOC_ED', iocc=icomp, scal=dtedyo, nbret=inod)

!      print *, "adding a bearing"

      call add_bearing(nbpal, typ_palier, omega, dtedyo, iddl, defmod )



!--   finally we update the indices

      call nlsav(sd_nl, _MAX_LEVEL, 1, iscal=ilevel)
      call dtmsav(sd_dtm, _NB_NONLI, 1, iscal=ilevel)
      !call nlsav (sd_nl , _NB_PALIE, 1, iscal=nbpal)

      AS_DEALLOCATE(vi = iddl)

!      print *, "fin prepa donne"

      



      
!     
      call jedema()


end subroutine
