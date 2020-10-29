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
! person_in_charge: mickael.abbas at edf.fr
!
module HHO_quadrature_module
!
use HHO_type
use HHO_measure_module
use HHO_geometry_module, only : hhoGeomBasis, hhoGeomDerivBasis
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/elraga.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/provec.h"
#include "asterfort/utmess.h"
#include "blas/dnrm2.h"
#include "jeveux.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO - generic
!
! Module to generate quadratures used for HHO
!
! --------------------------------------------------------------------------------------------------
!
    type HHO_Quadrature
        integer                             :: order = 0
        integer                             :: nbQuadPoints = 0
        real(kind=8), dimension(3,MAX_QP)   :: points = 0.d0
        real(kind=8), dimension(MAX_QP)     :: weights = 0.d0
! ----- member functions
        contains
        procedure, private, pass :: hho_edge_rules
        procedure, private, pass :: hho_tri_rules
        procedure, private, pass :: hho_quad_rules
        procedure, private, pass :: hho_tetra_rules
        procedure, private, pass :: hho_hexa_rules
        procedure, private, pass :: hho_pyram_rules
        procedure, private, pass :: hho_prism_rules
        procedure, public,  pass :: GetQuadCell => hhoGetQuadCell
        procedure, public,  pass :: GetQuadFace => hhoGetQuadFace
        procedure, public,  pass :: print => hhoQuadPrint
        procedure, public,  pass :: initCell => hhoinitCellFamiQ
        procedure, public,  pass :: initFace => hhoinitFaceFamiQ
    end type
!
!===================================================================================================
!
!===================================================================================================
!
    public   :: HHO_Quadrature
    private  :: hho_edge_rules, hho_hexa_rules, hho_tri_rules, hho_tetra_rules, &
                hho_transfo_hexa, hho_transfo_quad, &
                hho_transfo_prism, hho_transfo_pyram, &
                hho_prism_rules, hho_pyram_rules, &
                hho_quad_rules, hhoGetQuadCell, hhoGetQuadFace, hhoQuadPrint, &
                hhoinitCellFamiQ, hhoinitFaceFamiQ, check_order, hhoSelectOrder
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine check_order(order, maxAutorized)
!
    implicit none
!
        integer, intent(in) :: order
        integer, intent(in) :: maxAutorized
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   control the order of integration of order has to be included in [0, maxAutorized]
!   In order  : order of integration
!   In maxAutorized : maximum autorized order
!
! --------------------------------------------------------------------------------------------------
!
        if(order > maxAutorized) then
            call utmess('F', 'HHO1_2', ni=2, vali=(/order, maxAutorized /))
        end if
!
        if(order < 0) then
            call utmess('F', 'HHO1_3', si=order)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
! --------------------------------------------------------------------------------------------------
!       !!!! BE CAREFULL ALL THE TRANSFORMATIONS ARE LINEAR (PLANAR ELEMENTS) !!!!
! --------------------------------------------------------------------------------------------------
   subroutine hho_edge_rules(this, coorno, measure, barycenter)
!
    implicit none
!
        real(kind=8), dimension(3,2), intent(in)        :: coorno
        real(kind=8), intent(in)                        :: measure
        real(kind=8), dimension(3), intent(in)          :: barycenter
        class(HHO_quadrature), intent(inout)            :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules for an edge
!   In coorno       : coordinates of the nodes
!   In measure      : length of the edge
!   In barycenter   : barycenter
!   Out this        : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: meas_2
        real(kind=8), dimension(3) :: v1
        integer, parameter :: max_order = 7
        integer, parameter :: max_pg = 4
        character(len=8), dimension(0:max_order) ::rules
        integer :: dimp, nbpg, ipg
        real(kind=8), dimension(max_pg) :: xpg, poidpg
!
! ----- check order of integration
        call check_order(this%order,max_order)
!
        rules = (/ 'FPG1', 'FPG1', 'FPG2', 'FPG2', 'FPG3', 'FPG3', 'FPG4', 'FPG4' /)
!
        meas_2 = measure / 2.d0
        v1 = (coorno(1:3,2) - coorno(1:3,1)) / 2.d0
!
!------ get quadrature points
        xpg = 0.d0
        poidpg = 0.d0
        call elraga('SE2', rules(this%order), dimp, nbpg, xpg, poidpg)
!
! ----- fill hhoQuad
        ASSERT(nbpg <= MAX_QP)
        this%nbQuadPoints = nbpg
!
        do ipg = 1, nbpg
            this%points(1:3,ipg) = barycenter + xpg(ipg) * v1
            this%weights(ipg) = meas_2 * poidpg(ipg)
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hho_transfo_quad(coorno, coorref, ndim, jacob, coorac)
!
    implicit none
!
        real(kind=8), dimension(3,4), intent(in)            :: coorno
        real(kind=8), dimension(2), intent(in)              :: coorref
        integer, intent(in)                                 :: ndim
        real(kind=8), intent(out)                           :: jacob
        real(kind=8), dimension(3), intent(out), optional   :: coorac
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   From reference element to current element
!   In coorno       : coordinates of the nodes
!   In coorref      : coordinates in the reference conf
!   In ndim         : topological dimenison (space where live the quad)
!   Out coorac      : coordinates in the current conf
!   Out jacob       : determiant of the jacobienne of the transformation
!
! --------------------------------------------------------------------------------------------------
!
        character(len=8), parameter :: typema = 'QUAD4'
        real(kind=8), dimension(8) :: basis
        real(kind=8), dimension(3,8) :: dbasis
        real(kind=8), dimension(2,2) :: jaco
        real(kind=8), dimension(3) :: da, db, normal
        integer :: i
!
        if(present(coorac)) then
!
! ----      shape function
!
            call hhoGeomBasis(typema, (/ coorref(1), coorref(2), 0.d0  /), basis)
!
            coorac = 0.d0
!
            do i = 1, 4
                coorac(1:3) = coorac(1:3) + coorno(1:3, i) * basis(i)
            end do
        end if
!
!       derivative of shape function
!
        call hhoGeomDerivBasis(typema, (/ coorref(1), coorref(2), 0.d0  /), dbasis)
!
! ---  Compute the jacobienne
        jacob = 0.d0
        select case (ndim)
            case (2)
                jaco = 0.d0
                do i = 1, 4
                    jaco(1:2,1) = jaco(1:2,1) + coorno(1, i) * dbasis(1:2,i)
                    jaco(1:2,2) = jaco(1:2,2) + coorno(2, i) * dbasis(1:2,i)
                end do
!
                jacob = jaco(1,1) * jaco(2,2) - jaco(1,2) * jaco(2,1)
            case (3)
                da = 0.d0
                db = 0.d0
                do i = 1, 4
                    da(1:3) = da(1:3) + coorno(1:3,i) * dbasis(1,i)
                    db(1:3) = db(1:3) + coorno(1:3,i) * dbasis(2,i)
                end do
                call provec(da, db, normal)
                jacob = dnrm2(3, normal, 1)
            case default
                ASSERT(ASTER_FALSE)
        end select
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hho_quad_rules(this, coorno, ndim)
!
    implicit none
!
        real(kind=8), dimension(3,4), intent(in)        :: coorno
        integer, intent(in)                             :: ndim
        class(HHO_quadrature), intent(inout)            :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules for an quad
!   In coorno       : coordinates of the nodes
!   In ndim         : topological dimenison (space where live the quad)
!   Out this        : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3) ::  coorpgglo
        integer, parameter :: max_order = 7
        integer, parameter :: max_pg = 16
        character(len=8), dimension(0:max_order) ::rules
        integer :: dimp, nbpg, ipg
        real(kind=8) :: coorpg(max_pg * 2), poidpg(max_pg), x, y, jaco
!
! ----- check order of integration
        call check_order(this%order,max_order)
!
        rules = (/ 'FPG1 ', 'FPG1 ', 'FPG4 ', 'FPG4 ', 'FPG9 ', 'FPG9 ', 'FPG16', 'FPG16' /)
!
!------ get quadrature points
        coorpg = 0.d0
        poidpg = 0.d0
        call elraga('QU4', rules(this%order), dimp, nbpg, coorpg, poidpg)
!
! ----- fill hhoQuad
        ASSERT(nbpg <= MAX_QP)
        this%nbQuadPoints = nbpg
!
        do ipg = 1, nbpg
            x = coorpg(dimp * (ipg -1) + 1)
            y = coorpg(dimp * (ipg -1) + 2)
            call hho_transfo_quad(coorno, (/x,y/), ndim, jaco, coorpgglo)
            this%points(1:3,ipg) = coorpgglo
            this%weights(ipg) = abs(jaco) * poidpg(ipg)
        end do
!
    end subroutine
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hho_transfo_hexa(coorno, coorref, coorac, jacob)
!
    implicit none
!
        real(kind=8), dimension(3,8), intent(in)        :: coorno
        real(kind=8), dimension(3), intent(in)          :: coorref
        real(kind=8), dimension(3), intent(out)         :: coorac
        real(kind=8), intent(out)                       :: jacob
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   From reference element to current element
!   In coorno       : coordinates of the nodes
!   In coorref      : coordinates in the reference conf
!   Out coorac      : coordinates in the current conf
!   Out jacob       : determiant of the jacobienne of the transformation
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(8) :: basis
        real(kind=8), dimension(3,8) :: dbasis
        real(kind=8), dimension(3,3) :: jaco
        character(len=8), parameter :: typema = 'HEXA8'
        integer :: i
!
! ----- shape function
!
        call hhoGeomBasis(typema, coorref, basis)
!
! ----- derivative of shape function
!
        call hhoGeomDerivBasis(typema, coorref, dbasis)
!
        coorac = 0.d0
!
        do i = 1, 8
            coorac(1:3) = coorac(1:3) + coorno(1:3, i) * basis(i)
        end do
!
! ---  Compute the jacobienne
        jaco = 0.d0
        do i = 1, 8
            jaco(1:3,1) = jaco(1:3,1) + coorno(1, i) * dbasis(1:3,i)
            jaco(1:3,2) = jaco(1:3,2) + coorno(2, i) * dbasis(1:3,i)
            jaco(1:3,3) = jaco(1:3,3) + coorno(3, i) * dbasis(1:3,i)
        end do
!
        jacob = 0.d0
        jacob =   jaco(1,1) * jaco(2,2) * jaco(3,3) + jaco(1,3) * jaco(2,1) * jaco(3,2) &
                + jaco(3,1) * jaco(1,2) * jaco(2,3) - jaco(3,1) * jaco(2,2) * jaco(1,3) &
                - jaco(3,3) * jaco(2,1) * jaco(1,2) - jaco(1,1) * jaco(2,3) * jaco(3,2)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hho_hexa_rules(this, coorno)
!
    implicit none
!
        real(kind=8), dimension(3,8), intent(in)        :: coorno
        class(HHO_quadrature), intent(inout)            :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules for an hexhedra
!   In coorno       : coordinates of the nodes
!   Out this        : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: jaco
        real(kind=8), dimension(3) :: coorac
        integer, parameter :: max_order = 7
        integer, parameter :: max_pg = 64
        character(len=8), dimension(0:max_order) :: rules
        integer :: dimp, nbpg, ipg
        real(kind=8) :: coorpg(max_pg * 3), poidpg(max_pg), x, y, z
!
! ----- check order of integration
        call check_order(this%order,max_order)
!
        rules = (/ 'FPG1 ', 'FPG1 ', 'FPG8 ', 'FPG8 ', 'FPG27', 'FPG27', 'FPG64', 'FPG64' /)
!
!------ get quadrature points
        coorpg = 0.d0
        poidpg = 0.d0
        call elraga('HE8', rules(this%order), dimp, nbpg, coorpg, poidpg)
!
! ----- fill hhoQuad
        ASSERT(nbpg <= MAX_QP)
        this%nbQuadPoints = nbpg
!
        do ipg = 1, nbpg
            x = coorpg(dimp * (ipg -1) + 1)
            y = coorpg(dimp * (ipg -1) + 2)
            z = coorpg(dimp * (ipg -1) + 3)
            call hho_transfo_hexa(coorno, (/x,y,z/), coorac, jaco)
            this%points(1:3,ipg) = coorac(1:3)
            this%weights(ipg) = abs(jaco) * poidpg(ipg)
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hho_tri_rules(this, coorno, measure)
!
    implicit none
!
        real(kind=8), dimension(3,3), intent(in)        :: coorno
        real(kind=8), intent(in)                        :: measure
        class(HHO_quadrature), intent(inout)            :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules for a atriangle
!   In coorno       : coordinates of the nodes
!   In measure      : surface of the triangle
!   Out this        : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3) ::  gamma, beta, alpha
        integer, parameter :: max_order = 8
        integer, parameter :: max_pg = 16
        character(len=8), dimension(0:max_order) ::rules
        integer :: dimp, nbpg, ipg
        real(kind=8) :: coorpg(max_pg * 2), poidpg(max_pg), x, y, deuxmeas
!
! ----- check order of integration
        call check_order(this%order,max_order)
!
        rules = (/ 'FPG1 ', 'FPG1 ', 'FPG3 ', 'FPG4 ', 'FPG6 ', 'FPG7 ', 'FPG12', 'FPG13', 'FPG16'/)
!
        alpha = coorno(1:3,1)
        gamma = coorno(1:3,2) - coorno(1:3,1)
        beta  = coorno(1:3,3) - coorno(1:3,1)
        deuxmeas = 2.d0 * measure
!
!------ get quadrature points
        coorpg = 0.d0
        poidpg = 0.d0
        call elraga('TR3', rules(this%order), dimp, nbpg, coorpg, poidpg)
!
! ----- fill hhoQuad
        ASSERT(nbpg <= MAX_QP)
        this%nbQuadPoints = nbpg
!
        do ipg = 1, nbpg
            x = coorpg(dimp * (ipg -1) + 1)
            y = coorpg(dimp * (ipg -1) + 2)
            this%points(1:3,ipg) = alpha + beta * x + gamma * y
            this%weights(ipg) = deuxmeas * poidpg(ipg)
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hho_tetra_rules(this, coorno, measure)
!
    implicit none
!
        real(kind=8), dimension(3,4), intent(in)        :: coorno
        real(kind=8), intent(in)                        :: measure
        class(HHO_quadrature), intent(inout)            :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules for a tetrahedra
!   In coorno       : coordinates of the nodes
!   In measure      : volume of the tetrahedra
!   Out this        : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3) ::  gamma, beta, alpha, kappa
        integer, parameter :: max_order = 6
        integer, parameter :: max_pg = 23
        character(len=8), dimension(0:max_order) :: rules
        integer :: dimp, nbpg, ipg
        real(kind=8) :: coorpg(max_pg * 3), poidpg(max_pg), x, y, z, sixmeas
!
! ----- check order of integration
        call check_order(this%order,max_order)
!
        rules = (/ 'FPG1 ', 'FPG1 ', 'FPG4 ', 'FPG5 ', 'FPG11', 'FPG15', 'FPG23'/)
!
        alpha  = coorno(1:3,3)
        gamma  = coorno(1:3,1) - coorno(1:3,3)
        beta   = coorno(1:3,4) - coorno(1:3,3)
        kappa  = coorno(1:3,2) - coorno(1:3,3)
        sixmeas = 6.d0 * measure
!
!------ get quadrature points
        coorpg = 0.d0
        poidpg = 0.d0
        call elraga('TE4', rules(this%order), dimp, nbpg, coorpg, poidpg)
!
! ----- fill hhoQuad
        ASSERT(nbpg <= MAX_QP)
        this%nbQuadPoints = nbpg
!
        do ipg = 1, nbpg
            x = coorpg(dimp * (ipg -1) + 1)
            y = coorpg(dimp * (ipg -1) + 2)
            z = coorpg(dimp * (ipg -1) + 3)
            this%points(1:3,ipg) = alpha + beta * x + gamma * y + kappa * z
            this%weights(ipg) = sixmeas * poidpg(ipg)
        end do
!
    end subroutine
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hho_transfo_pyram(coorno, coorref, coorac, jacob)
!
    implicit none
!
        real(kind=8), dimension(3,5), intent(in)        :: coorno
        real(kind=8), dimension(3), intent(in)          :: coorref
        real(kind=8), dimension(3), intent(out)         :: coorac
        real(kind=8), intent(out)                       :: jacob
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   From reference element to current element
!   In coorno       : coordinates of the nodes
!   In coorref      : coordinates in the reference conf
!   Out coorac      : coordinates in the current conf
!   Out jacob       : determiant of the jacobienne of the transformation
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(8) :: basis
        real(kind=8), dimension(3,8) :: dbasis
        real(kind=8), dimension(3,3) :: jaco
        character(len=8), parameter :: typema = 'PYRAM5'
        integer :: i
!
! ----- shape function
!
        call hhoGeomBasis(typema, coorref, basis)
!
! ----- derivative of shape function
!
        call hhoGeomDerivBasis(typema, coorref, dbasis)
!
        coorac = 0.d0
!
        do i = 1, 5
            coorac(1:3) = coorac(1:3) + coorno(1:3, i) * basis(i)
        end do
!
! ---  Compute the jacobienne
        jaco = 0.d0
        do i = 1, 5
            jaco(1:3,1) = jaco(1:3,1) + coorno(1, i) * dbasis(1:3,i)
            jaco(1:3,2) = jaco(1:3,2) + coorno(2, i) * dbasis(1:3,i)
            jaco(1:3,3) = jaco(1:3,3) + coorno(3, i) * dbasis(1:3,i)
        end do
!
        jacob = 0.d0
        jacob =   jaco(1,1) * jaco(2,2) * jaco(3,3) + jaco(1,3) * jaco(2,1) * jaco(3,2) &
                + jaco(3,1) * jaco(1,2) * jaco(2,3) - jaco(3,1) * jaco(2,2) * jaco(1,3) &
                - jaco(3,3) * jaco(2,1) * jaco(1,2) - jaco(1,1) * jaco(2,3) * jaco(3,2)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hho_pyram_rules(this, coorno)
!
    implicit none
!
        real(kind=8), dimension(3,5), intent(in)        :: coorno
        class(HHO_quadrature), intent(inout)            :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules for a pyramid
!   In coorno       : coordinates of the nodes
!   Out this        : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: jaco, x, y, z
        real(kind=8), dimension(3) :: coorac
        integer, parameter :: max_order = 5
        integer, parameter :: max_pg = 27
        character(len=8), dimension(0:max_order) :: rules
        integer :: dimp, nbpg, ipg
        real(kind=8) :: coorpg(max_pg * 3), poidpg(max_pg)
!
! ----- check order of integration
        call check_order(this%order,max_order)
!
        rules = (/ 'FPG1 ', 'FPG5 ', 'FPG5 ', 'FPG6 ', 'FPG27', 'FPG27'/)
!
!------ get quadrature points
        coorpg = 0.d0
        poidpg = 0.d0
        call elraga('PY5', rules(this%order), dimp, nbpg, coorpg, poidpg)
!
! ----- fill hhoQuad
        ASSERT(nbpg <= MAX_QP)
        this%nbQuadPoints = nbpg
!
        do ipg = 1, nbpg
            x = coorpg(dimp * (ipg -1) + 1)
            y = coorpg(dimp * (ipg -1) + 2)
            z = coorpg(dimp * (ipg -1) + 3)
            call hho_transfo_pyram(coorno, (/x,y,z/), coorac, jaco)
            this%points(1:3,ipg) = coorac(1:3)
            this%weights(ipg) = abs(jaco) * poidpg(ipg)
        end do
!
    end subroutine
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hho_transfo_prism(coorno, coorref, coorac, jacob)
!
    implicit none
!
        real(kind=8), dimension(3,6), intent(in)        :: coorno
        real(kind=8), dimension(3), intent(in)          :: coorref
        real(kind=8), dimension(3), intent(out)         :: coorac
        real(kind=8), intent(out)                       :: jacob
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   From reference element to current element
!   In coorno       : coordinates of the nodes
!   In coorref      : coordinates in the reference conf
!   Out coorac      : coordinates in the current conf
!   Out jacob       : determiant of the jacobienne of the transformation
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(8) :: basis
        real(kind=8), dimension(3,8) :: dbasis
        real(kind=8), dimension(3,3) :: jaco
        character(len=8), parameter :: typema = 'PENTA6'
        integer :: i
!
! ----- shape function
!
        call hhoGeomBasis(typema, coorref, basis)
!
! ----- derivative of shape function
!
        call hhoGeomDerivBasis(typema, coorref, dbasis)
!
        coorac = 0.d0
!
        do i = 1, 6
            coorac(1:3) = coorac(1:3) + coorno(1:3, i) * basis(i)
        end do
!
! ---  Compute the jacobienne
        jaco = 0.d0
        do i = 1, 6
            jaco(1:3,1) = jaco(1:3,1) + coorno(1, i) * dbasis(1:3,i)
            jaco(1:3,2) = jaco(1:3,2) + coorno(2, i) * dbasis(1:3,i)
            jaco(1:3,3) = jaco(1:3,3) + coorno(3, i) * dbasis(1:3,i)
        end do
!
        jacob = 0.d0
        jacob =   jaco(1,1) * jaco(2,2) * jaco(3,3) + jaco(1,3) * jaco(2,1) * jaco(3,2) &
                + jaco(3,1) * jaco(1,2) * jaco(2,3) - jaco(3,1) * jaco(2,2) * jaco(1,3) &
                - jaco(3,3) * jaco(2,1) * jaco(1,2) - jaco(1,1) * jaco(2,3) * jaco(3,2)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hho_prism_rules(this, coorno)
!
    implicit none
!
        real(kind=8), dimension(3,6), intent(in)        :: coorno
        class(HHO_quadrature), intent(inout)            :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules for a prism
!   In coorno       : coordinates of the nodes
!   Out this        : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: jaco
        real(kind=8), dimension(3) :: coorac
        integer, parameter :: max_order = 5
        integer, parameter :: max_pg = 21
        character(len=8), dimension(0:max_order) :: rules
        integer :: dimp, nbpg, ipg
        real(kind=8) :: coorpg(max_pg * 3), poidpg(max_pg), x, y, z
!
! ----- check order of integration
        call check_order(this%order,max_order)
!
        rules = (/ 'FPG1 ', 'FPG6 ', 'FPG6 ', 'FPG8 ', 'FPG21', 'FPG21'/)
!
!------ get quadrature points
        coorpg = 0.d0
        poidpg = 0.d0
        call elraga('PE6', rules(this%order), dimp, nbpg, coorpg, poidpg)
!
! ----- fill hhoQuad
        ASSERT(nbpg <= MAX_QP)
        this%nbQuadPoints = nbpg
!
        do ipg = 1, nbpg
            x = coorpg(dimp * (ipg -1) + 1)
            y = coorpg(dimp * (ipg -1) + 2)
            z = coorpg(dimp * (ipg -1) + 3)
            call hho_transfo_prism(coorno, (/x,y,z/), coorac, jaco)
            this%points(1:3,ipg) = coorac(1:3)
            this%weights(ipg) = abs(jaco) * poidpg(ipg)
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGetQuadCell(this, hhoCell, order)
!
    implicit none
!
        type(HHO_cell), intent(in)            :: hhoCell
        integer, intent(in)                   :: order
        class(HHO_quadrature), intent(out)    :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules for the current cell
!   In hhoCell      : a HHO cell
!   In order        : quadrature order
!   Out this        : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        this%order = order
!
        if(hhoCell%typema == 'HEXA8') then
            call this%hho_hexa_rules(hhoCell%coorno(1:3,1:8))
        elseif(hhoCell%typema == 'TETRA4') then
            call this%hho_tetra_rules(hhoCell%coorno(1:3,1:4), hhoCell%measure)
        elseif(hhoCell%typema == 'PYRAM5') then
            call this%hho_pyram_rules(hhoCell%coorno(1:3,1:5))
        elseif(hhoCell%typema == 'PENTA6') then
            call this%hho_prism_rules(hhoCell%coorno(1:3,1:6))
        elseif(hhoCell%typema == 'QUAD4') then
            call this%hho_quad_rules(hhoCell%coorno(1:3,1:4), 2)
        elseif(hhoCell%typema == 'TRIA3') then
            call this%hho_tri_rules(hhoCell%coorno(1:3,1:3), hhoCell%measure)
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGetQuadFace(this, hhoFace, order)
!
    implicit none
!
        type(HHO_face), intent(in)          :: hhoFace
        integer, intent(in)                 :: order
        class(HHO_quadrature), intent(out)  :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules for the current face
!   In hhoFace      : a HHO face
!   In order        : quadrature order
!   Out this     : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        this%order = order
!
        if(hhoFace%typema(1:5) == 'QUAD4') then
            call this%hho_quad_rules(hhoFace%coorno(1:3,1:4), 3)
        elseif(hhoFace%typema(1:5) == 'TRIA3') then
            call this%hho_tri_rules(hhoFace%coorno(1:3,1:3), hhoFace%measure)
        elseif(hhoFace%typema(1:4) == 'SEG2') then
            call this%hho_edge_rules(hhoFace%coorno(1:3,1:2), hhoFace%measure, hhoFace%barycenter)
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoSelectOrder(typema, npg, order)
!
    implicit none
!
        character(len=8), intent(in)  :: typema
        integer, intent(in)           :: npg
        integer, intent(out)          :: order
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the order of the quadrature rules from a familly definied in the catalogue of code_aster
!   In typema   : type of Cell or Face
!   In npg      : number of quadrature points
!   Out order   : order of the quadrature
!
! --------------------------------------------------------------------------------------------------
!
        order = 0
!
        if(typema == 'HEXA8') then
            select case (npg)
                case (1)
                    order = 1
                case (8)
                    order = 3
                case (27)
                    order = 5
                case (64)
                    order = 7
                case default
                    ASSERT(ASTER_FALSE)
            end select
        elseif(typema == 'PENTA6') then
            select case (npg)
                case (1)
                    order = 0
                case (6)
                    order = 2
                case (8)
                    order = 3
                case (21)
                    order = 5
                case default
                    ASSERT(ASTER_FALSE)
            end select
        elseif(typema == 'PYRAM5') then
            select case (npg)
                case (1)
                    order = 0
                case (5)
                    order = 2
                case (6)
                    order = 3
                case (27)
                    order = 5
                case default
                    ASSERT(ASTER_FALSE)
            end select
        elseif(typema == 'TETRA4') then
            select case (npg)
                case (1)
                    order = 1
                case (4)
                    order = 2
                case (5)
                    order = 3
                case (11)
                    order = 4
                case (15)
                    order = 5
                case (23)
                    order = 6
                case default
                    ASSERT(ASTER_FALSE)
            end select
        elseif(typema == 'QUAD4') then
            select case (npg)
                case (1)
                    order = 1
                case (4)
                    order = 3
                case (9)
                    order = 5
                case (16)
                    order = 7
                case default
                    ASSERT(ASTER_FALSE)
            end select
        elseif(typema == 'TRIA3') then
            select case (npg)
                case (1)
                    order = 1
                case (3)
                    order = 2
                case (4)
                    order = 3
                case (6)
                    order = 4
                case (7)
                    order = 5
                case (12)
                    order = 6
                case (13)
                    order = 7
                case (16)
                    order = 8
                case default
                    ASSERT(ASTER_FALSE)
            end select
        elseif(typema == 'SEG2') then
            select case (npg)
                case (1)
                    order = 1
                case (2)
                    order = 3
                case (3)
                    order = 5
                case (4)
                    order = 7
                case default
                    ASSERT(ASTER_FALSE)
            end select
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoinitCellFamiQ(this, hhoCell, npg)
!
    implicit none
!
        type(HHO_cell), intent(in)          :: hhoCell
        integer, intent(in)                 :: npg
        class(HHO_quadrature), intent(out)  :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules from a familly definied in the catalogue of code_aster
!   In hhoCell  : hhoCell
!   In npg      : number of quadrature points
!   Out this    : hho quadrature
!
! --------------------------------------------------------------------------------------------------
        integer :: order
!
        ASSERT(npg .le. MAX_QP)
        this%nbQuadPoints = npg
!
        call hhoSelectOrder(hhoCell%typema, npg, order)
!
        call hhoGetQuadCell(this, hhoCell, order)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoinitFaceFamiQ(this, hhoFace, npg)
!
    implicit none
!
        type(HHO_Face), intent(in)          :: hhoFace
        integer, intent(in)                 :: npg
        class(HHO_quadrature), intent(out)  :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get the quadrature rules from a familly definied in the catalogue of code_aster
!   In hhoFace  : hhoFace
!   In npg      : number of quadrature points
!   Out this    : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        integer :: order
!
        ASSERT(npg .le. MAX_QP)
        this%nbQuadPoints = npg
!
        call hhoSelectOrder(hhoFace%typema, npg, order)
!
        call hhoGetQuadFace(this, hhoFace, order)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoQuadPrint(this)
!
    implicit none
!
        class(HHO_quadrature), intent(in)  :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Print quadrature informations
!   In this    : hho quadrature
!
! --------------------------------------------------------------------------------------------------
!
        integer :: ipg
!
        write(6,*) "QUADRATURE INFORMATIONS"
        write(6,*) "number of qp: ", this%nbQuadPoints
        write(6,*) "order: ", this%order
!
        do ipg = 1, this%nbQuadPoints
            write(6,*) "coordo qp ", ipg, ":", this%points(1:3, ipg)
            write(6,*) "weight qp ", ipg, ":", this%weights(ipg)
        end do
        write(6,*) "END QUADRATURE INFORMATIONS"
!
    end subroutine
!
end module
