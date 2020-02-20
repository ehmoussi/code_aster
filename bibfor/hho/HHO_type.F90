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
module HHO_type
!
implicit none
!
#include "asterf_types.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Define types for datastructures
!
! --------------------------------------------------------------------------------------------------
!
    type HHO_Field
!
        aster_logical      :: l_debug = ASTER_FALSE
! ----- Inconnues sur la cellule: previous time
        character(len=19)  :: fieldPrev_cell = ''
! ----- Inconnues sur la cellule: current time
        character(len=19)  :: fieldCurr_cell = ''
! ----- Inconnues sur la cellule: increment
        character(len=19)  :: fieldIncr_cell = ''
! ----- Inconnues sur la cellule - Condensation statique (matrice)
        character(len=19)  :: fieldOUT_cell_MT = ''
! ----- Inconnues sur la cellule - Condensation statique (second membre)
        character(len=19)  :: fieldOUT_cell_RT = ''
! ----- Inconnues sur la cellule - Precalcul gradient (matrice)
        character(len=19)  :: fieldOUT_cell_GT = ''
! ----- Inconnues sur la cellule - Precalcul stabilisation (matrice)
        character(len=19)  :: fieldOUT_cell_ST = ''
! ----- Inconnues sur les noeuds pour post-traitement
        character(len=19)  :: fieldCurr_nodes = ''
! ----- Matrix and vector after combination
        character(len=19)  :: vectcomb = ''
        character(len=19)  :: matrcomb = ''
! ----- Vecteur second membre
        character(len=19)  :: vect_elem = ''
        character(len=19)  :: vect_asse = ''
! ----- Fields for error
        character(len=19)  :: stat_cond_error = ''
! ----- Fields for Dirichlet loads
        aster_logical      :: l_cine_f = ASTER_FALSE
        character(len=19)  :: fieldCineFunc = ''
        character(len=19)  :: fieldCineVale = ''
        integer, pointer :: v_info_cine(:) => null()
        integer :: nb_cmp_hho = 0
!
    end type HHO_Field
!
!===================================================================================================
!
!===================================================================================================
!
    type HHO_Data
        aster_logical      :: l_debug = ASTER_FALSE
! ----- Ordre inconnues face
        integer            :: m_face_degree
! ----- Ordre inconnues cellule
        integer            :: m_cell_degree
! ----- Ordre inconnues grad
        integer            :: m_grad_degree
! ----- Stabilisation ?
        aster_logical      :: l_stab
! ----- Precompute operator ?
        aster_logical      :: l_precalc
! ----- Adapt stabilization coefficient ?
        aster_logical      :: l_adapt_coef
! ----- Coefficient stabilisation
        real(kind=8)       :: m_coeff_stab
! ----- member function
        contains
        procedure, pass    :: initialize => initialize_data
        procedure, pass    :: face_degree
        procedure, pass    :: cell_degree
        procedure, pass    :: grad_degree
        procedure, pass    :: debug => debug_data
        procedure, pass    :: stabilize
        procedure, pass    :: precompute
        procedure, pass    :: adapt
        procedure, pass    :: coeff_stab
        procedure, pass    :: setCoeffStab
        procedure, pass    :: print => print_data
    end type HHO_Data
!
!===================================================================================================
!
!===================================================================================================
!
    type HHO_Face
! ----- Dimension topologique
        integer                     :: ndim = 0
! ----- Type maille
        character(len=8)            :: typema = ''
! ----- Nombre de noeuds
        integer                     :: nbnodes = 0
! ----- Coordonnees des noeuds   (max 4 noeuds pour quad)
        real(kind=8), dimension(3,4):: coorno = 0.d0
! ----- Coordonnees du barycentre de la face
        real(kind=8), dimension(3)  :: barycenter = 0.d0
! ----- Diametre de la face
        real(kind=8)                :: diameter = 0.d0
! ----- Surface ou longueur de la face
        real(kind=8)                :: measure = 0.d0
! ----- Normale sortante
        real(kind=8), dimension(3)  :: normal = 0.d0
! ----- Local basis
        real(kind=8), dimension(3,2):: local_basis = 0.d0
! ----- Coeff_ONB (orthonormal basis)
        real(kind=8), dimension(6,6):: coeff_ONB = 0.d0
! ----- member function
        contains
        procedure, public, pass :: print => print_face
    end type HHO_Face
!
!===================================================================================================
!
!===================================================================================================
!
    type HHO_Cell
! ----- Dimension topologique
        integer                     :: ndim = 0
! ----- Type maille
        character(len=8)            :: typema = ''
! ----- Nombre de noeuds
        integer                     :: nbnodes = 0
! ----- Coordonnees des noeuds   (max 27 noeuds pour hexa)
        real(kind=8), dimension(3,27):: coorno = 0.d0
! ----- Coordonnees du barycentre de la cellule
        real(kind=8), dimension(3)  :: barycenter = 0.d0
! ----- Diametre de la cellule
        real(kind=8)                :: diameter = 0.d0
! ----- Longueur de la boite englobante (orientee ou non) de la cellule
        real(kind=8), dimension(3)  :: length_box = 0.d0
! ----- Volume ou Surface de la cellule
        real(kind=8)                :: measure = 0.d0
! ----- Nombre de faces de la cellule
        integer                     :: nbfaces = 0
! ----- Donnees sur les faces (max 6 faces pour hexa)
        type(HHO_Face), dimension(6):: faces
! ----- member function
        contains
        procedure, public, pass :: print => print_cell
    end type HHO_Cell
!
contains
!
!---------------------------------------------------------------------------------------------------
! -- member function for HHO_Data type
!---------------------------------------------------------------------------------------------------
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine initialize_data(this, face_degree, cell_degree, grad_degree, l_stab, coeff, l_debug,&
                               l_precalc, l_adapt_coef)
!
    implicit none
!
        class(HHO_Data), intent(inout)  :: this
        integer, intent(in)             :: face_degree
        integer, intent(in)             :: cell_degree
        integer, intent(in)             :: grad_degree
        aster_logical, intent(in)       :: l_stab
        aster_logical, intent(in)       :: l_precalc
        aster_logical, intent(in)       :: l_adapt_coef
        real(kind=8), intent(in)        :: coeff
        aster_logical, intent(in)       :: l_debug
!
! --------------------------------------------------------------------------------------------------
!
!   initialization of a HHO_DATA type
!   In this     : a HHo Data
!   In face_degree
!   In cell_degree
!   In grad_degree
!   In l_stab   : stabilize yes or no ?
!   In l_precalc: precompute yes or no ?
!   In l_adapt_coef: adapt automatically the coefficient yes or no ?
!   In coeff    : coefficient of stabilization
!   In l_debug  : debug yes or no ?
! --------------------------------------------------------------------------------------------------
!
        this%m_face_degree = face_degree
        this%m_cell_degree = cell_degree
        this%m_grad_degree = grad_degree
        this%l_stab = l_stab
        this%l_precalc = l_precalc
        this%l_adapt_coef = l_adapt_coef
        this%m_coeff_stab = coeff
        this%l_debug = l_debug
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    function face_degree(this) result(degree)
!
    implicit none
!
        class(HHO_Data), intent(in) :: this
        integer                     :: degree
!
! --------------------------------------------------------------------------------------------------
!
!   return the face degree of a HHO_DATA type
!   In this     : a HHo Data
!   Out degree  : face_degree
! --------------------------------------------------------------------------------------------------
!
        degree = this%m_face_degree
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function cell_degree(this) result(degree)
!
    implicit none
!
        class(HHO_Data), intent(in) :: this
        integer                     :: degree
!
! --------------------------------------------------------------------------------------------------
!
!   return the cell degree of a HHO_DATA type
!   In this     : a HHo Data
!   Out degree  : cell_degree
! --------------------------------------------------------------------------------------------------
!
        degree = this%m_cell_degree
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function grad_degree(this) result(degree)
!
    implicit none
!
        class(HHO_Data), intent(in) :: this
        integer                     :: degree
!
! --------------------------------------------------------------------------------------------------
!
!   return the grad degree of a HHO_DATA type
!   In this     : a HHo Data
!   Out degree  : grad_degree
! --------------------------------------------------------------------------------------------------
!
        degree = this%m_grad_degree
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function debug_data(this) result(logic)
!
    implicit none
!
        class(HHO_Data), intent(in) :: this
        logical                     :: logic
!
! --------------------------------------------------------------------------------------------------
!
!   return the debug logical of a HHO_DATA type
!   In this     : a HHo Data
!   Out logic   : debug yes or no ?
! --------------------------------------------------------------------------------------------------
!
        logic = this%l_debug
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function stabilize(this) result(logic)
!
    implicit none
!
        class(HHO_Data), intent(in) :: this
        logical                     :: logic
!
! --------------------------------------------------------------------------------------------------
!
!   return the stab logical of a HHO_DATA type
!   In this     : a HHo Data
!   Out logic   : stabilize yes or no ?
! --------------------------------------------------------------------------------------------------
!
        logic = this%l_stab
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function precompute(this) result(logic)
!
    implicit none
!
        class(HHO_Data), intent(in) :: this
        logical                     :: logic
!
! --------------------------------------------------------------------------------------------------
!
!   return the precalc logical of a HHO_DATA type
!   In this     : a HHo Data
!   Out logic   : precompute yes or no ?
! --------------------------------------------------------------------------------------------------
!
        logic = this%l_precalc
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function adapt(this) result(logic)
!
    implicit none
!
        class(HHO_Data), intent(in) :: this
        logical                     :: logic
!
! --------------------------------------------------------------------------------------------------
!
!   adapt automatically the stabilization parameter
!   In this     : a HHo Data
!   Out logic   : adapt yes or no ?
! --------------------------------------------------------------------------------------------------
!
        logic = this%l_adapt_coef
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function coeff_stab(this) result(coeff)
!
    implicit none
!
        class(HHO_Data), intent(in) :: this
        real(kind=8)                :: coeff
!
! --------------------------------------------------------------------------------------------------
!
!   return the stabilization coefficient of a HHO_DATA type
!   In this     : a HHo Data
!   Out coeff   : coefficient of stabilization
! --------------------------------------------------------------------------------------------------
!
        coeff = this%m_coeff_stab
!
    end function
!===================================================================================================
!
!===================================================================================================
!
    subroutine setCoeffStab(this, coeff)
!
    implicit none
!
        class(HHO_Data), intent(inout) :: this
        real(kind=8), intent(in)       :: coeff
!
! --------------------------------------------------------------------------------------------------
!
!   give the stabilization coefficient of a HHO_DATA type
!   In this     : a HHo Data
!   In coeff   : coefficient of stabilization
! --------------------------------------------------------------------------------------------------
!
        this%m_coeff_stab = coeff
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine print_data(this)
!
    implicit none
!
        class(HHO_Data), intent(in) :: this
!
! --------------------------------------------------------------------------------------------------
!
!   print informations of a HHO_DATA type
!   In this     : a HHo Data
! --------------------------------------------------------------------------------------------------
!
        write(6,*) "hhoData debug"
        write(6,*) "face degree: ", this%face_degree()
        write(6,*) "cell degree: ", this%cell_degree()
        write(6,*) "grad degree: ", this%grad_degree()
        write(6,*) "stab ?: ",      this%stabilize()
        write(6,*) "coeff stab: ",  this%coeff_stab()
        write(6,*) "end hhoData debug"
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
!---------------------------------------------------------------------------------------------------
! -- member function for HHO_Face type
!---------------------------------------------------------------------------------------------------
!
    subroutine print_face(this)
!
    implicit none
!
        class(HHO_Face), intent(in) :: this
!
! --------------------------------------------------------------------------------------------------
! Print information about the face
! In this              : a HHO Face
! --------------------------------------------------------------------------------------------------
!
        integer :: inode
! --------------------------------------------------------------------------------------------------
        write(6,*) "Informations on HHO Face"
        write(6,*) "Type maille: ", this%typema
        write(6,*) "Dimension topo: ", this%ndim
        write(6,*) "Number of nodes: ", this%nbnodes
        do inode = 1, this%nbnodes
            write(6,*) "    node", inode, ": ", this%coorno(1:3, inode)
        end do
        write(6,*) "Barycenter: ", this%barycenter
        write(6,*) "Normal: ", this%normal
        write(6,*) "Measure: ", this%measure
        write(6,*) "Diameter: ", this%diameter
        write(6,*) "Local basis: "
        write(6,*) "    b1: ", this%local_basis(1:3,1)
        if(this%ndim > 1) then
            write(6,*) "    b2: ", this%local_basis(1:3,2)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
!---------------------------------------------------------------------------------------------------
! -- member function for HHO_Cell type
!---------------------------------------------------------------------------------------------------
!
    subroutine print_cell(this)
!
    implicit none
!
        class(HHO_Cell), intent(in) :: this
!
! --------------------------------------------------------------------------------------------------
!   Print information about the cell
! In this              : a HHO Cell
! --------------------------------------------------------------------------------------------------
!
        integer :: inode, iface
!
        write(6,*) "Informations on HHO Cell"
        write(6,*) "Type maille: ", this%typema
        write(6,*) "Dimension topo: ", this%ndim
        write(6,*) "Number of nodes: ", this%nbnodes
        do inode = 1, this%nbnodes
            write(6,*) "    node", inode, ": ", this%coorno(1:3, inode)
        end do
        write(6,*) "Barycenter: ", this%barycenter
        write(6,*) "Measure: ", this%measure
        write(6,*) "Diameter: ", this%diameter
        write(6,*) "Length box: ", this%length_box
        write(6,*) "Number of face: ", this%nbfaces
        do iface = 1, this%nbfaces
            write(6,*) "    face", iface, ": "
            call this%faces(iface)%print()
        end do
!
    end subroutine
!
end module
