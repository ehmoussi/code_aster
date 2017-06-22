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

module yacs_module
    implicit none
!
! person_in_charge: mohamed-amine.hassini@edf.fr
!
!---------------------------------------------------------------------------
! This module is in charge of all kind of communication between 
! aster and yacs
!---------------------------------------------------------------------------

#include "jeveux.h"
#include "asterfort/jeveuo.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/errcou.h"
#include "asterc/cpedb.h"
#include "asterc/cpldb.h"
#include "asterc/cpeen.h"
#include "asterc/cplen.h"
#include "asterc/cpech.h"
#include "asterc/cplch.h"





    private :: clean_port

    public ::  port, add_port, icompo , get_port_by_name, delete_port
    public :: com_port
    public :: PORT_IN, PORT_OUT


    type port
        character(len=144) :: name
        integer            :: direction 
        type(port), pointer :: next => null()
        real(kind=8), pointer :: vr(:) => null()
        integer(kind=4), pointer :: vi4(:) => null()
        character(len=8), pointer :: vk8(:) => null()
    end type port





    ! ports will be a linked list !
    type(port), pointer :: first_port=> null()


    ! YACS
    integer :: icompo
    integer(kind=4), parameter :: cpiter = 41
    integer(kind=4), parameter :: izero4 = 0
    real(kind=4),    parameter :: dzero4 = 0.0

    integer, parameter :: PORT_IN = -1
    integer, parameter :: PORT_OUT = 1


    


    contains



!--

       subroutine initialize_compo()
          integer, pointer :: ic(:) => null()
          call jeveuo('&ADR_YACS','L', vi=ic)
          icompo=ic(1)
       end subroutine




!--

      logical function are_ports_equals( p1, p2)
        type(port), pointer, intent(in) :: p1, p2

        are_ports_equals = .false.

        if( associated(p1) .and. associated(p2)) then

            if(p1%name == p2%name) then
                are_ports_equals = .true.
            end if

        endif

      end function are_ports_equals



!--


      subroutine get_port_by_name(port_name, fport)
          character(len=*), intent(in) :: port_name
          type(port), intent(out), pointer :: fport
          logical :: exist
          call is_port_exist(port_name, exist, fport)
          ASSERT( exist )          
      end subroutine



!--

       subroutine com_port( fport, itime, time)
            type(port), intent(in) :: fport
            integer, intent(in) :: itime
            real(kind=8), intent(in) :: time


            integer(kind=4) :: nele4, info4, nlu, itime4
            real(kind=4) :: time4

            call initialize_compo()
            
            itime4=itime
            time4=time

            if( fport%direction .eq. PORT_OUT) then
               
               if (associated(fport%vr)) then
                  nele4 = size(fport%vr)
                  call cpedb(icompo, cpiter, time, itime4,&
                            fport%name, nele4, fport%vr , info4 )
                  call errcou('Writing ', itime4, fport%name, info4, nele4, nele4)
               endif

               if (associated(fport%vi4)) then
                  nele4 = size(fport%vi4)
                  call cpeen(icompo, cpiter, time4, itime4, &
                            fport%name, nele4, fport%vi4, info4 )
                  call errcou('Writing ', itime4, fport%name, info4, nele4, nele4)
               endif

               if (associated(fport%vk8)) then
                  nele4 = size(fport%vk8)
                  call cpech(icompo, cpiter, time4, itime4, &
                            fport%name, nele4, fport%vk8(1) , info4 )
                  call errcou('Writing ', itime4, fport%name, info4, nele4, nele4)
               endif 
              

            else

               if(associated(fport%vr)) then
                    nele4 = size(fport%vr)
                    call cpldb(icompo, cpiter, time, time, itime4,&
                              fport%name, nele4, nlu, fport%vr, info4)
                    call errcou('Reading ', itime4, fport%name, info4, nele4, nlu) 
               endif

               if(associated(fport%vi4)) then
                    nele4 = size(fport%vi4)
                    time4 = time
                    call cplen(icompo, cpiter, time4, time4, itime4,&
                              fport%name, nele4, nlu, fport%vi4, info4)
                    call errcou('Reading ', itime4, fport%name, info4, nele4, nlu) 
               endif

               if(associated(fport%vi4)) then
                    nele4 = size(fport%vk8)
                    time4 = time
                    call cplch(icompo, cpiter, time4, time4, itime4, &
                              fport%name, nele4, nlu, fport%vk8(1), info4)
                    call errcou('Reading ', itime4, fport%name, info4, nele4, nlu) 
               endif

            endif

       end subroutine


       subroutine add_port(  name , direction, nvalues, typ)
           implicit none
           character(len=*), intent(in) :: name
           integer, intent(in) :: direction
           integer, intent(in) :: nvalues
           character(len=*), intent(in), optional :: typ
           logical exist 

           ! for foundport
           type(port), pointer :: fport => null() 

           if( .not. associated(first_port) ) then
              allocate(first_port)
              fport => first_port

           else

              call is_port_exist(name, exist, fport )
              ASSERT(.not. exist)
              allocate(fport%next)
              fport => fport%next                        
           endif

           fport%name =name
           fport%direction = direction

           if(.not. present(typ)) then
              AS_ALLOCATE(vr=fport%vr, size=nvalues)
           else
              select case (trim(typ))
                case ('I4')
                    AS_ALLOCATE(vi4=fport%vi4, size=nvalues)
                case ('R8')
                    AS_ALLOCATE(vr=fport%vr,   size=nvalues)
                case ('K8')
                    AS_ALLOCATE(vk8 = fport%vk8, size=nvalues)
                case default
                   ASSERT(.false.)
              end select
           endif
       end subroutine


       subroutine is_port_exist(  name, exist, current )
           character(len=*), intent(in) :: name
           logical , intent(out) :: exist
           type(port), pointer, intent(out), optional :: current =>null()

           exist = .false.


           if(associated(first_port)) then

               current => first_port

               do
                    if (trim(current%name) == trim(name) ) then
                        exist = .true.
                        exit
                    endif

                    if( .not. associated( current%next) ) then
                        exit
                    endif

                    current => current%next
                    
               end do
           endif

       end subroutine


! ---


        subroutine delete_port(  fport )
            type(port), pointer, intent(inout) :: fport

            type(port), pointer :: precedent => null()

            if( associated(fport) ) then

                ! first you need to find the preceeding port
                precedent => first_port

                if( are_ports_equals(fport, first_port) ) then
                        first_port => first_port % next
                        call clean_port(precedent)
                else
                    call get_previous_element( fport, precedent )
                    ASSERT( associated(precedent) )
                    precedent%next => fport%next
                    call clean_port(fport)
                endif
            endif





        end subroutine 


!--

        subroutine get_previous_element(element, backele)
            ! return the element before
            type(port), pointer, intent(in)  :: element
            type(port), pointer, intent(out) :: backele => null()
            type(port), pointer              :: current => null()

            current => first_port

            do while ( associated( current ) )
                if( are_ports_equals( current%next, element ) ) then
                    backele => current
                    exit
                endif
                current => current%next
            end do

        end subroutine

!--

        subroutine clean_port(fport)
            type(port), pointer, intent(inout) :: fport

            if(associated(fport%vr)) then
                AS_DEALLOCATE( vr = fport%vr )

            endif
            if(associated(fport%vi4)) then
                AS_DEALLOCATE(vi4= fport%vi4)

            endif

            if(associated(fport%vk8)) then
                AS_DEALLOCATE(vk8=fport%vk8)
            endif

            nullify(fport%next)
            deallocate(fport)

        end subroutine





end module
