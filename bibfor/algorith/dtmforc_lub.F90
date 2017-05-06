subroutine dtmforc_lub(sd_dtm_, sd_nl_, buffdtm, buffnl,&
                        time, itime, dt, depl, vite, fext)

    use lub_module, only: first_bearing, bearing, communicate, init_com_with_edyos
    implicit none
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
!
! person_in_charge: mohamed-amine.hassini@edf.fr
!
! dtmforc_lub : send displacemets, velocity to the bearing program through 
!               yacs and receive force using yacs at the current step (t)
!             -> A special module lub_module is used to perform the task of 
!                cummunication
!
!       sd_dtm_, buffdtm : dtm data structure and its buffer
!       sd_nl_ , buffnl  : nl  data structure and its buffer
!       time,dt          : current instant t, time step
!       itime            : current time step iteration
!       depl, vite       : structural modal displacement and velocity at "t"
!       fext             : projected total non-linear force
!
! =======================================================================


#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nlget.h"
#include "asterfort/dtmget.h"
#include "asterfort/nlsav.h"


!     1. Input / output arguments
      character(len=*)      , intent(in)  :: sd_dtm_
      character(len=*)      , intent(in)  :: sd_nl_
      integer     , pointer , intent(in)  :: buffdtm  (:)
      integer     , pointer , intent(in)  :: buffnl   (:)
      real(kind=8), pointer , intent(in)  :: depl     (:)
      real(kind=8), pointer , intent(in)  :: vite     (:)
      real(kind=8), pointer , intent(out) :: fext     (:)
      real(kind=8),           intent(in)  :: time, dt
      integer               , intent(in)  :: itime



!     2. Local variable
      real(kind=8), pointer               :: dplmod   (:)   => null()      
      character(len=8)                    :: sd_dtm, sd_nl
      integer                             :: i,j, nbmodes 


      type(bearing), pointer              :: cb => null()
      integer, parameter                  :: nddl = 2

      real(kind=8)                        :: dtini, tinit, tfin
      integer                             :: nbpas
      logical , save                      :: premier_passage = .true.




!--

      ! thanks for visiting
      if(.not.associated(first_bearing)) return



      call jemarq()

!      print *, "dtform called"

      sd_dtm = sd_dtm_
      sd_nl = sd_nl_
      

      ! this call should be performed from dtmprep_noli_lub not from here !
      ! but i can't do it since time step is not set when dtmprep_noli_xxx are called
      !
      if (premier_passage) then
            premier_passage = .false.
            call dtmget(sd_dtm, _DT, rscal = dtini)
            call dtmget(sd_dtm, _INST_INI, rscal = tinit)
            call dtmget(sd_dtm, _INST_FIN, rscal = tfin)
            call dtmget(sd_dtm, _NB_STEPS, iscal = nbpas)
            call init_com_with_edyos(nbpas, tinit, tfin, dtini)
!            print *, "NBPAS => ", nbpas
!            print *, "TINIT => ", tinit
!            print *, "tfin => ", tfin
!            print *, "dtinit=>", dtini
      endif


      ! in order to have parallel computing it is better 
      ! to send all information regarding all bearing and then receive
      ! all responses that's why there is two while loops 

      cb => first_bearing

      do while( associated( cb ) )
            ! retrieve modal basis
            dplmod => cb%defmod

            ! retrieve the number of modes
            nbmodes = cb%nbmodes

            cb%depl(:)  = 0.0
            cb%vite(:)  = 0.0
            cb%force(:) = 0.0

            do j=1, nbmodes
                do i=1, 2
                    cb%depl(i)= cb%depl(i) + dplmod(nddl*(j-1)+i)*depl(j)
                    cb%vite(i)= cb%vite(i) + dplmod(nddl*(j-1)+i)*vite(j)
                end do
            end do

            cb => cb%next

      end do


      ! send and recieve
      call communicate(itime+1, time, dt)


      cb => first_bearing

      do while ( associated( cb ) )

            dplmod => cb%defmod
            nbmodes = cb%nbmodes
            

            ! now transform force from the physical to modal coordinates

            do j=1, nbmodes
                do i=1, 2
                   fext(j) = fext(j) + dplmod(nddl*(j-1)+i)*cb%force(i)
                end do
            end do

            cb => cb%next

      end do

      call jedema()

end subroutine
