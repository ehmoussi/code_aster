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

module yacsnl_module
    use yacs_module, only : port, add_port, PORT_IN, PORT_OUT, &
        get_port_by_name, com_port, delete_port, com_port
    implicit none
!
! person_in_charge: mohamed-amine.hassini@edf.fr
! 
!
!---------------------------------------------------------------------------
! This module is in charge of the nonlinearities defined in dyna_vibra and
! meant to be communicated to other coupled codes through yacs
!---------------------------------------------------------------------------


#include "asterfort/assert.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"

private :: clean_trandata, build_trandata
public ::  finalize, add_trandata, set_params
public :: CHAM_DEPL, CHAM_VITE, CHAM_FORCE

    type trandata
        integer :: num
        type(port), pointer :: data_port
        integer, pointer :: iddl(:) => null()
        real(kind=8), pointer :: defmod(:) => null()
        type(trandata), pointer :: next => null()
        integer :: nddl = 0
        integer :: nbmodes = 0
        integer :: type_cham = 0
    end type trandata

    integer, save :: count = 0
    logical, save :: initialized = .false.


    ! defining some useful constants
    integer, parameter :: CHAM_DEPL  = 1
    integer, parameter :: CHAM_VITE  = 2
    integer, parameter :: CHAM_FORCE = 3



    type(trandata), pointer :: first_trandata => null()

    ! this port will have the following information
    ! tini, tend, current_time, time_step
    type(port), pointer :: paramr => null()

    ! this port will have the following information
    ! current iteration
    type(port), pointer :: parami => null()


#define _TINI 1
#define _TEND 2
#define _CURRENT_TIME 3
#define _DT 4
#define _DTMIN 5
#define _DTMAX 6
#define _CURRENT_TIME_STEP 1



contains

!--
        subroutine add_trandata(num, port_name, cham, list_ddl,  mdefmod )
            integer , intent(in) :: num
            character(len=*), intent(in) :: port_name
            integer , pointer , intent(in) :: list_ddl(:)
            real(kind=8), pointer , intent(in) :: mdefmod(:)
            character(len=*), intent(in) :: cham
            integer :: nele, n
            logical :: exist = .false.

            integer :: tc


            type(trandata), pointer :: mytd => null()

            if( num.lt.0) then
                ASSERT(.false.)
            endif

            nele = size(list_ddl)
            n= size(mdefmod)

            tc = get_type_cham(cham)


            
            if( .not. associated( first_trandata ) ) then
                call build_trandata(num, port_name, tc, nele, 'R8', first_trandata)
                ! TODO : move what is next inside build_trandata subroutine
                AS_ALLOCATE(vi=first_trandata%iddl, size= nele)
                AS_ALLOCATE(vr=first_trandata%defmod, size= n)
                first_trandata%iddl = list_ddl
                first_trandata%nddl = nele
                first_trandata%nbmodes = n / nele
                first_trandata%type_cham = tc
            else
                call is_trandata_exist(num, exist, mytd)
                ASSERT(.not.exist)
                call build_trandata( num, port_name, tc, nele, 'R8', mytd%next )
                AS_ALLOCATE(vi=mytd%next%iddl, size= nele)
                AS_ALLOCATE(vr=mytd%next%defmod, size= n)
                mytd%next%iddl = list_ddl
                mytd%next%nddl = nele
                mytd%next%nbmodes = n / nele
                mytd%next%type_cham = tc
            endif

            count = count + 1

        end subroutine





!---

        subroutine delete_trandata(mtd)

            type(trandata), pointer, intent(inout) :: mtd
            type(trandata), pointer :: precedent => null()


            precedent => first_trandata


            if( are_trandata_equals(mtd, first_trandata ) ) then

                first_trandata => first_trandata % next              
                call clean_trandata(precedent)
                count = count - 1

            else

                call get_previous_element( mtd, precedent )
                ASSERT( associated(precedent) )
                precedent % next => mtd % next
                call clean_trandata(mtd)
                count = count - 1

            endif

        end subroutine


!--    

        subroutine get_previous_element(element, backele)
            ! return the element before
            type(trandata), pointer, intent(in)  :: element
            type(trandata), pointer, intent(out) :: backele 
            type(trandata), pointer              :: current => null()
            
            backele => null()
            current => first_trandata

            do while ( associated( current ) )
                if( are_trandata_equals( current%next, element ) ) then
                    backele => current
                    exit
                endif
                current => current%next
            end do

        end subroutine


!--

        subroutine is_trandata_exist(num, exist, current)
            integer , intent(in) :: num
            logical , intent(out) :: exist
            type(trandata), pointer, intent (out), optional :: current 
            
            current => null()
            exist = .false.

            if(associated(first_trandata)) then

                current => first_trandata

                do 
                    if( num .eq. current%num) then
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



!----


       subroutine finalize()
            ! clean everything
            ! first clean paramr and parami

            if( associated( paramr) ) then
                call delete_port(paramr)
            endif

            if( associated( parami) ) then
                call delete_port(parami)
            endif

            ! delete every first_data from the list

            do while(associated(first_trandata))
                call delete_trandata(first_trandata)
            end do

       end subroutine



!--

       subroutine send_values( td, values, itime, time )

            ! project values into physical base and then send it through yacs
            real(kind=8), pointer, intent(in) :: values(:)
            type(trandata), pointer, intent(in):: td
            integer, intent(in) :: itime
            real(kind=8), intent(in) :: time

            integer :: i,j, nddl, nbmodes

            td%data_port%vr(:) = 0.0
            nbmodes = td%nbmodes
            nddl = td%nddl

            td%data_port%vr(:) = 0.0

            do j=1, nbmodes
                do i =1, nddl
                    td%data_port%vr(i) = td%data_port%vr(i) + td%defmod(nddl*(j-1)+i)*values(j)
                end do
            end do

            call com_port(td%data_port, itime, time)

       end subroutine


!--

        subroutine retrieve_values( td, values, itime, time )
            type(trandata), pointer , intent(in) :: td
            real(kind=8), intent(out) :: values(:)
            real(kind=8), intent(in) :: time
            integer, intent(in) :: itime

            integer :: i,j, nbmodes, nddl

            ! retrieve data from yacs and then project it to gene base

            call com_port(td%data_port, itime, time)

            nbmodes = td%nbmodes
            nddl = td%nddl

            do j=1, nbmodes

                do i=1, nddl
                    values(j) = values(j) + td%defmod(nddl*(j-1)+i) * td%data_port%vr(i)
                end do

            end do


        end subroutine


!--

        subroutine set_params(itime, time, tinit, tfin, dt, dtmin, dtmax)

            integer, intent(in) :: itime
            real(kind=8), intent(in) :: time, dt, tinit, tfin, dtmin, dtmax

            !

            if( .not. initialized ) then
                call add_port('PARAMR', PORT_OUT, 6, 'R8')
                call get_port_by_name('PARAMR', paramr)

                call add_port('PARAMI', PORT_OUT, 1, 'I4')
                call get_port_by_name('PARAMI', parami)

                initialized = .true.
            endif



           ! write some information on the ports and send them

           paramr%vr(_TINI) = tinit
           paramr%vr(_TEND) = tfin
           paramr%vr(_CURRENT_TIME) = time
           paramr%vr(_DT) = dt
           paramr%vr(_DTMIN) = dtmin
           paramr%vr(_DTMAX) = dtmax

           parami%vi4(_CURRENT_TIME_STEP) = 1

           call com_port(paramr, 1, time)
           call com_port(parami, 1, time)


        end subroutine






!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!!!!   PRIVATE SUBROTINE AND FUNCTION

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!
        subroutine clean_trandata(mtd)
            type(trandata), pointer , intent(inout) :: mtd

            if(.not.associated( mtd )) return 

!            print *, "cleaning trandata num #" , mtd%num

            call delete_port(mtd%data_port)

            AS_DEALLOCATE(vi=mtd%iddl)
            AS_DEALLOCATE(vr=mtd%defmod)

            nullify( mtd%next )

            deallocate(mtd)

        end subroutine




!-- 

        subroutine build_trandata(num, port_name, type_cham, nele, typ,  trd)
            ! this subroutine should be private
            integer , intent(in) :: num
            character(len=*), intent(in) :: port_name
            integer, intent(in) :: type_cham
            character(len=*), intent(in) :: typ
            integer, intent(in) :: nele
            type(trandata), pointer, intent(out) :: trd

            integer :: dir

            if( associated(trd) ) then
                ASSERT(.false.)
            endif 

            allocate( trd )

            trd % num = num

            select case (type_cham)

                case(CHAM_DEPL)
                    dir = PORT_IN

                case(CHAM_VITE)
                    dir = PORT_OUT

                case(CHAM_FORCE)
                    dir = PORT_IN

                case default
                    ASSERT(.false.)

            end select

            call add_port( trim(port_name), dir , nele, typ)

            call get_port_by_name(trim(port_name), trd%data_port)

        end subroutine



!--


        logical function are_trandata_equals( b1, b2)

            type(trandata), pointer, intent(in) :: b1, b2

            are_trandata_equals = .false.

            if( associated(b1) .and. associated(b2) ) then
                if( b1%num .eq. b2%num ) then
                    are_trandata_equals = .true.
                endif
            endif

        end function are_trandata_equals


!--

        integer function get_type_cham(cham)
            character(len=*), intent(in):: cham

            integer resu

            if( cham(1:4).eq.'DEPL') then

                resu = CHAM_DEPL

            elseif (cham(1:4).eq.'VITE') then

                resu = CHAM_VITE

            elseif( cham(1:5) .eq. 'FORCE' ) then

                resu = CHAM_FORCE

            else
                ASSERT(.false.)
            endif

            get_type_cham = resu

        end function




end module
