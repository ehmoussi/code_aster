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
!
module calcG_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcG_type.h"

!
! --------------------------------------------------------------------------------------------------
!
! CALC_G
!
! Define types for datastructures
!
! --------------------------------------------------------------------------------------------------
!
    type CalcG_Field
!
        aster_logical      :: l_debug = ASTER_FALSE
! ----- name of result (in)
        character(len=8)   :: result_in = ' '
! ----- type of result (in)
        character(len=16)  :: result_in_type = ' '
! ----- name of table container (out)
        character(len=8)   :: table_out = ' '
! ----- topological dimension
        integer            :: ndim      = 0
! ----- topological dimension
        integer            :: nb_order = 0
! ----- number option to compute
        integer            :: nb_option = 0
! ----- list of options
        character(len=8)   :: list_option(MAX_NB_OPT) = ' '
! ----- level information
        integer            :: level_info = 1
        contains
        procedure, pass    :: initialize => initialize_field
        procedure, pass    :: print      => print_field
!
    end type CalcG_Field
!
!===================================================================================================
!
!===================================================================================================
!
    type CalcG_Study
! ----- name of model
        character(len=8)   :: modele    = ' '
! ----- name of mesh
        character(len=8)   :: mesh      = ' '
! ----- name of material
        character(len=24)  :: material  = ' '
! ----- name of coded material
        character(len=24)  :: mateco    = ' '
! ----- index order
        integer            :: nume_ordre = -1
! ----- member function
        contains
        procedure, pass    :: initialize => initialize_study
        ! procedure, pass    :: face_degree
        ! procedure, pass    :: cell_degree
        ! procedure, pass    :: grad_degree
        ! procedure, pass    :: debug => debug_data
        ! procedure, pass    :: stabilize
        ! procedure, pass    :: precompute
        ! procedure, pass    :: adapt
        ! procedure, pass    :: coeff_stab
        ! procedure, pass    :: setCoeffStab
        ! procedure, pass    :: print => print_data
    end type CalcG_Study
!
!===================================================================================================
!
!===================================================================================================
!
    type CalcG_Theta
! ----- name of theta field
        character(len=8)   :: theta_field = ' '
! ----- name of crack
        character(len=8)   :: crack = ' '
! ----- type of crack
        character(len=8)   :: crack_type = ' '
! ----- nodes of the crack
        character(len=24)   :: fondNoeud = ' '
! ----- size estimation of radial diameter of cells
        character(len=24)   :: fondTailleR = ' '
! ----- curvilign abscise
        character(len=24)   :: abscurv = ' '
! ----- local coordinate of nodes
        character(len=24)   :: basloc = ' '
! ----- member function
        contains
        procedure, pass    :: initialize => initialize_theta
        procedure, pass    :: print => print_theta
        ! procedure, pass    :: cell_degree
        ! procedure, pass    :: grad_degree
        ! procedure, pass    :: debug => debug_data
        ! procedure, pass    :: stabilize
        ! procedure, pass    :: precompute
        ! procedure, pass    :: adapt
        ! procedure, pass    :: coeff_stab
        ! procedure, pass    :: setCoeffStab
        ! procedure, pass    :: print => print_data
    end type CalcG_Theta
!
!
contains
!
!---------------------------------------------------------------------------------------------------
! -- member functions
!---------------------------------------------------------------------------------------------------
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine initialize_field(this)
!
    implicit none
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/gettco.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
!
        class(CalcG_Field), intent(inout)  :: this
!
! --------------------------------------------------------------------------------------------------
!
!   initialization of a CalcG_Field type
!   In this     : calG field
! --------------------------------------------------------------------------------------------------
!
        integer :: ier, ifm
        character(len=16) :: k16bid
        character(len=8)  :: modele
!
        call jemarq()
!
! --- Concept de sortie (table container)
!
        call getres(this%table_out, k16bid, k16bid)
!
! --- Get name and type of result (in)
!
        call getvid(' ', 'RESULTAT', scal=this%result_in, nbret=ier)
        ASSERT(ier==1)
        call gettco(this%result_in, this%result_in_type, ASTER_TRUE)
        call dismoi('MODELE', this%result_in, 'RESULTAT', repk=modele)
        call dismoi('DIM_GEOM', modele, 'MODELE', repi=this%ndim)
!
! --- Get name of option
!
        call getvtx(' ', 'OPTION', nbret=ier)
        this%nb_option = -ier
        ASSERT(this%nb_option <= MAX_NB_OPT)
        call getvtx(' ', 'OPTION', nbval=this%nb_option, vect=this%list_option)
!
! --- Level of information
!
        call infniv(ifm, this%level_info)
!
        if(this%level_info > 1) then
            call this%print()
        end if
!
        call jedema()
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine print_field(this)
!
    implicit none
!
        class(CalcG_Field), intent(in)  :: this
!
! --------------------------------------------------------------------------------------------------
!
!   initialization of a CalcG_Field type
!   In this     : calG field
! --------------------------------------------------------------------------------------------------
!
        integer :: i
!
        print*, "Informations about CalcG_Field"
        print*, "Level of informations: ", this%level_info
        print*, "Dimension of the problem: ", this%ndim
        print*, "Result: ", this%result_in, " of type ", this%result_in_type
        print*, "Output: ", this%table_out
        print*, "Number of option to compute: ", this%nb_option
        do i =1, this%nb_option
            print*, "** option ", i, ": ", this%list_option(i)
        end do
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine initialize_study(this)
!
    implicit none
!
        class(CalcG_Study), intent(inout)  :: this
!
! --------------------------------------------------------------------------------------------------
!
!   initialization of a CalcG_Field type
!   In this     : calG field
! --------------------------------------------------------------------------------------------------
!
        this%modele = "AA"
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine initialize_theta(this)
!
    implicit none
!
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/gettco.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
!
        class(CalcG_Theta), intent(inout)  :: this
!
! --------------------------------------------------------------------------------------------------
!
!   initialization of a CalcG_Theta type
!   In this     : theta type
! --------------------------------------------------------------------------------------------------
!
        call jemarq()
! --- to do get name
        this%theta_field = "&&THETA"
!
! --- get informations about the crack
!
        call getvid('THETA', 'FISSURE', iocc=1, scal=this%crack)
        call gettco(this%crack, this%crack_type, ASTER_TRUE)
! to do - type of discotinuity if xfem
!
        this%fondNoeud = this%crack//'.FOND.NOEUD'
        this%fondTailleR = this%crack//'.FOND.TAILLE_R'
        this%abscurv = this%crack//'.ABSCUR'
        this%basloc  = this%crack//'.BASLOC'





        call this%print()
        call jedema()
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine print_theta(this)
!
    implicit none
!
        class(CalcG_Theta), intent(in)  :: this
!
! --------------------------------------------------------------------------------------------------
!
!   print informations of a CalcG_Theta type
!   In this     : theta type
! --------------------------------------------------------------------------------------------------
!
        print*, "Informations about CalcG_Theta"
        print*, "Field theta: ", this%theta_field
        print*, "Crack: ", this%crack, "of type ", this%crack_type
!
    end subroutine
!
end module
