! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

module lub_module
    use yacs_module , only : port, add_port, PORT_IN, PORT_OUT, &
        get_port_by_name, com_port, delete_port
    implicit none

!
! person_in_charge: mohamed-amine.hassini@edf.fr
!
!---------------------------------------------------------------------------
! This module is in charge of all operaton related to edyos coupling
!---------------------------------------------------------------------------


#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterc/r8pi.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"

#define nmax_bearings  20

    private :: generate_name
    public :: bearing
    public :: add_bearing, get_bearing_by_num, communicate, init_com_with_edyos
    public :: delete_bearing, delete_all_bearings


    type bearing
         character(len=24) :: type
         character(len=24) :: name
         integer :: num
         real(kind=8) :: omega 
         real(kind=8) :: dtsto
         real(kind=8) :: tfin

         real(kind=8), pointer :: defmod(:) => null()
         integer,      pointer :: iddl(:)   => null()
         integer               :: nbmodes = 0
         integer               :: nddl = 0


         type(port), pointer :: force_port => null()
         type(port), pointer :: depvit_port => null()
         type(port), pointer :: paramr_port => null()
         type(port), pointer :: parami_port => null()
         type(port), pointer :: nom_ana_port => null()
         type(port), pointer :: mode_port => null()
         type(port), pointer :: reprise_port =>null()
         type(port), pointer :: type_ana_port =>null()

         real(kind=8), dimension(2) :: depl
         real(kind=8), dimension(2) :: vite
         real(kind=8), dimension(2) :: force


         type(bearing), pointer :: next => null()

         type(port), pointer :: lports => null()


    end type bearing


    type(bearing), pointer :: first_bearing => null()




    contains



!---

        subroutine delete_all_bearings()

            do while (associated(first_bearing))
                !print *, "deleting first bearing"
                call delete_bearing(first_bearing)
            end do

        end subroutine


! ---

        subroutine delete_bearing(mbearing)

            type(bearing), pointer, intent(inout) :: mbearing
            type(bearing), pointer :: precedent => null()


            ! delete all the port in his pocession

            precedent => first_bearing


            if( are_bearings_equals(mbearing, first_bearing ) ) then                           
                first_bearing => first_bearing % next              
                call clean_bearing(precedent)
            else

                call get_previous_element( mbearing, precedent )
                ASSERT( associated(precedent) )
                precedent%next => mbearing%next
                call clean_bearing(mbearing)
            endif

        end subroutine
!--

        subroutine get_previous_element(element, backele)
            ! return the element before
            type(bearing), pointer, intent(in)  :: element
            type(bearing), pointer, intent(out) :: backele 
            type(bearing), pointer              :: current => null()
            
            backele => null()
            current => first_bearing

            do while ( associated( current ) )
                if( are_bearings_equals( current%next, element ) ) then
                    backele => current
                    exit
                endif
                current => current%next
            end do

        end subroutine

!--


        subroutine add_bearing(num, typ, om, dtstoc, list_ddl, mdefmod)

            integer, intent(in) :: num
            character(len=*), intent(in) :: typ
            ! omega
            real(kind=8), intent(in) :: om 
            ! storage time that will be used by edyos
            real(kind=8), intent(in) :: dtstoc 
            real(kind=8), pointer, intent(in) :: mdefmod(:)
            integer,      pointer, intent(in) :: list_ddl(:)



            type(bearing), pointer :: mybearing => null()
            character(len=24) :: port_name
            logical :: exist

            ! check that there is no bearing with the same number

            if( .not. associated(first_bearing) ) then
              allocate(first_bearing)
              mybearing => first_bearing
            else
              call is_bearing_exist( num , exist , mybearing)
              ASSERT(.not. exist)
              allocate(mybearing%next)
              mybearing => mybearing%next
            endif


            mybearing%name = 'PALIER'
            mybearing%num = num
            mybearing%type = typ
            mybearing%omega = om
            mybearing%dtsto = dtstoc


            AS_ALLOCATE(vr=mybearing%defmod, size= size(mdefmod) )
            mybearing%defmod(:) = mdefmod(:)

            AS_ALLOCATE(vi=mybearing%iddl,  size = size(list_ddl))
            mybearing%iddl(:) = list_ddl(:)

            mybearing%nddl = size(list_ddl)
            mybearing%nbmodes = size(mybearing%defmod) / size(list_ddl)



            ! inlet ports

            call generate_name('FORCETE_', num, port_name)
            call add_port( trim(port_name), PORT_IN,  3, 'R8')
            call get_port_by_name( trim(port_name) , mybearing%force_port )


            call generate_name('TYPE_ANA1_', num, port_name)
            call add_port( trim(port_name) , PORT_IN, 1, 'K8')
            call get_port_by_name (trim(port_name), mybearing%type_ana_port)


            call generate_name('REPRISEASTER_', num, port_name)
            ! each bearing have a maximum of 24 pads and each pad need to send 6 component
            !144 = 6 * 24 (nombre max de patins)
            call add_port( trim(port_name), PORT_IN, 144, 'R8') 
            call get_port_by_name(trim(port_name), mybearing%reprise_port)


            ! outlet ports
            ! another port for outlets
            call generate_name('POSITION_', num, port_name)
            call add_port( trim(port_name), PORT_OUT, 11, 'R8')
            call get_port_by_name( trim(port_name), mybearing%depvit_port)

            !another for some additionnal information
            call generate_name('PARAMREEL_', num, port_name)
            call add_port( trim(port_name), PORT_OUT, 6, 'R8')
            call get_port_by_name( trim(port_name), mybearing%paramr_port)

            call generate_name('PARAMENTI_', num, port_name)
            call add_port( trim(port_name), PORT_OUT, 2, 'I4')
            call get_port_by_name( trim(port_name), mybearing%parami_port)


            call generate_name('NOM_ANA1_', num, port_name)
            call add_port( port_name, PORT_OUT, 1, 'K8')
            call get_port_by_name(port_name, mybearing%nom_ana_port)


            call generate_name('mode_', num, port_name)
            call add_port( trim(port_name), PORT_OUT, 1, 'I4')
            call get_port_by_name(trim(port_name), mybearing%mode_port)


        end subroutine



!--

        subroutine is_bearing_exist(num, exist, current)
            integer , intent(in) :: num
            logical , intent(out) :: exist
            type(bearing), pointer, intent (out), optional :: current 
           
            current => null()
            exist = .false.

            if(associated(first_bearing)) then

                current => first_bearing

                do
                    if( num.eq.current%num ) then
                        exist = .true.
                        exit
                    endif

                    if(.not.associated( current%next)) then
                        exit
                    endif

                    current => current%next
                end do

            endif


        end subroutine

!--

        subroutine get_bearing_by_num(num, fbearing)
           integer, intent(in) :: num
           type(bearing), pointer, intent(out) :: fbearing 
           logical :: exist
           fbearing => null()
           call is_bearing_exist(num, exist, fbearing)
           ASSERT(exist)
        end subroutine


!--

        subroutine communicate(itime, time, dt)
            integer, intent(in) :: itime
            real(kind=8), intent(in) :: time, dt
            type(bearing), pointer :: current => null()


            current => first_bearing

            do while( associated( current ))

                current%depvit_port%vr(1) = time               

                !if( current%tfin - time-dt .lt. 0.0) then
                !    current%depvit_port%vr(2) = current%tfin - time
                !else
                    current%depvit_port%vr(2) = dt
                !endif
                current%depvit_port%vr(3) = current%depl(1)
                current%depvit_port%vr(4) = current%depl(2)

                current%depvit_port%vr(5) = current%vite(1)
                current%depvit_port%vr(6) = current%vite(2)

                current%depvit_port%vr(7) = 0.0d0
                current%depvit_port%vr(8) = 0.0d0
                current%depvit_port%vr(9) = 0.0d0

                current%depvit_port%vr(10) = current%omega*r8pi()/30.d0
                current%depvit_port%vr(11) = current%dtsto
                call com_port(current%depvit_port, itime, time)

!                do i=1, 11
!                   print *, "sent value = " , current%depvit_port%vr(i) , " @", i, itime
!                end do


                current => current%next
            end do


            ! redo the same thing but with a reading process

            current => first_bearing

            do while( associated( current ) )
                ! edyos convergence

                call com_port(current%force_port, itime, time)

!                do i=1,3
!                   print *, "received value =", current%force_port%vr(i), " @", i , itime
!               end do 

                if( current%force_port%vr(1).le. 0.d0) then
                    call utmess('F', 'EDYOS_45')
                endif

                current%force(:)= current%force_port%vr(2:3)

                current => current%next
            end do

        end subroutine


!--   initialize the communication


        subroutine init_com_with_edyos(nbpas, tinit, tfin, dt)

            integer, intent(in) :: nbpas
            real(kind=8), intent(in) :: tinit, tfin, dt

            type(bearing), pointer :: current => null()

        
            current => first_bearing

            do while( associated (current) )

                ! send edyos name of the bearing
!                print *, "send the name "

                current%nom_ana_port%vk8(1) = current%name

                call com_port( current%nom_ana_port, 1, tinit)

                ! receive type of bearing from edyos

!                print *, "receive the type of bearing"

                call com_port( current%type_ana_port, 1, tinit)

!                print *, "this is what i received :", current%type_ana_port%vk8(1) , "@@"

                ! forget it we don't want the type of bearing anyway ! 

                ! now send some informations about time and time step

                current%paramr_port%vr(1) = tinit
                current%paramr_port%vr(2) = tfin
                current%paramr_port%vr(3) = dt
                current%paramr_port%vr(4) = current%dtsto
                current%paramr_port%vr(5) = current%omega
                current%paramr_port%vr(6) = 1d-11

!                print *, "sending PARAMR"
                call com_port(current%paramr_port, 1, tinit)

                ! sending tim step

                current%parami_port%vi4(1) = int(nbpas + 1,4)
                ! pas de reprise
                current%parami_port%vi4(2) = 0 
                current%tfin = tfin

!                print *, "send parami"

                call com_port(current%parami_port, 1, tinit)
                

                ! send first data
                current%depvit_port%vr(1) = 0.0
                current%depvit_port%vr(2) = dt
                current%depvit_port%vr(3) = 0.0
                current%depvit_port%vr(4) = 0.0
                current%depvit_port%vr(5) = 0.0
                current%depvit_port%vr(6) = 0.0
                current%depvit_port%vr(7) = 0.0
                current%depvit_port%vr(8) = 0.0
                current%depvit_port%vr(9) = 0.0
                current%depvit_port%vr(10) = current%omega*r8pi()/30.d0
                current%depvit_port%vr(11) = current%dtsto
                call com_port(current%depvit_port, 1, 0.0d0)

                current => current%next

            end do

!            print *, "end of init_com_with_edyos"

        end subroutine


!---



!-------------------------- PRIVATE -----------------


        subroutine generate_name(prefix, num, gene_name)
           character(len=*), intent(in) :: prefix
           integer , intent(in) :: num
           character(len=24), intent(out) :: gene_name

           character(len=2) :: numstr

           if (num .lt. 10) then
              write(numstr, "(I1)") num
           else
              write(numstr, "(I2)") num
           endif

           

           gene_name = trim(prefix) // trim(numstr)

        end subroutine


!----

        subroutine clean_bearing(mbearing)
            type(bearing), pointer , intent(inout) :: mbearing

            if(.not.associated( mbearing )) return 

!            print *, "cleaning bearing num #" , mbearing%num

            call delete_port(mbearing%depvit_port)

            call delete_port(mbearing%force_port)
            
            call delete_port(mbearing%paramr_port)
            call delete_port(mbearing%parami_port)

            call delete_port(mbearing%nom_ana_port)
            call delete_port(mbearing%mode_port)
            call delete_port(mbearing%reprise_port)
            call delete_port(mbearing%type_ana_port)


            AS_DEALLOCATE( vr = mbearing%defmod )
            AS_DEALLOCATE( vi = mbearing%iddl)


            nullify( mbearing%next )

            deallocate(mbearing)

        end subroutine


!--


        logical function are_bearings_equals( b1, b2)

            type(bearing), pointer, intent(in) :: b1, b2

            are_bearings_equals = .false.

            if( associated(b1) .and. associated(b2) ) then
                if( b1%num .eq. b2%num ) then
                    are_bearings_equals = .true.
                endif
            endif

        end function are_bearings_equals




end module
