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

module tenseur_meca_module
    implicit None
!
! person_in_charge: jean-luc.flejou at edf.fr
!
    integer, parameter :: dimspace = 3

    type vecteur
        real(kind=8) , dimension(dimspace) :: vect = 0.0d0
    end type vecteur

    type tenseur2
        integer :: ordre = 2
        real(kind=8) , dimension(dimspace,dimspace) :: tens = 0.0d0
    end type tenseur2

    type tenseur4
        integer :: ordre = 4
        real(kind=8) , dimension(dimspace,dimspace,dimspace,dimspace) :: tens = 0.0d0
    end type tenseur4

    type basepropre
        type(vecteur)  :: valep
        type(tenseur2) :: basep
        type(tenseur2) :: tensp
        type(vecteur)  :: vectp(3)
    end type basepropre

    type TracComp
        type(vecteur)  :: valept
        type(tenseur2) :: traction
        type(vecteur)  :: valepc
        type(tenseur2) :: compress
        logical        :: istraction = .false.
        logical        :: iscompress = .false.
    end type TracComp

    type SpheDev
        real(kind=8)   :: spherique
        type(tenseur2) :: deviateur
    end type SpheDev
    !
    private :: vecteur_vecteur, tenseur2_tenseur2, tenseur2_reel
    private :: tenseur2_vecteur, vecteur_tenseur
    private :: matrice_aster_tenseur4
    !
    private :: tenseur2_plus, tenseur2_moins
    private :: tenseur4_plus, tenseur4_moins
    !
    private :: tenseur2_mult_reel_r, tenseur2_mult_reel_l
    private :: tenseur4_mult_reel_r, tenseur4_mult_reel_l
    private :: tenseur2_mult_tenseur2, tenseur2_mult_vecteur
    private :: tenseur2_divise_reel, tenseur4_divise_reel
    !
    private :: tenseur2_trace
    private :: tenseur4_contract2_tenseur2
    !
    private :: tenseur2_transpose
    !
    private :: tenseur2_basepropre, passage_vers_base_propre, retour_vers_base_initiale
    !
    private :: tenseur2_TracComp
    !
    private :: vecteur_ptens_vecteur
    !
    private :: tenseur_vers_vecteur_aster, vecteur_aster_vers_tenseur
    private :: vecteur_vers_vecteur_aster, vecteur_aster_vers_vecteur
    private :: tenseur_vers_vecteur
    !
    private :: signe_vecteur
    !
    private :: identite2
    !
    private :: deviateur_spherique_T2, deviateur_spherique_Vect, vecteur_deviateur_spherique
    private :: tenseur_deviateur_spherique_T2, tenseur_deviateur_spherique_Vect
    !
    private ::  raideur_elas
    !
    private :: vecteur_vers_tenseur, jacobi
    !
    interface assignment(=)
        module procedure vecteur_vecteur
        module procedure tenseur2_tenseur2
        module procedure tenseur2_reel
        module procedure tenseur2_vecteur
        module procedure vecteur_tenseur
        module procedure matrice_aster_tenseur4
    end interface

    interface operator(+)
        module procedure tenseur2_plus
        module procedure tenseur4_plus
    end interface
    interface operator(-)
        module procedure tenseur2_moins
        module procedure tenseur4_moins
    end interface

    interface operator(*)
        module procedure tenseur2_mult_reel_r
        module procedure tenseur2_mult_reel_l
        module procedure tenseur4_mult_reel_r
        module procedure tenseur4_mult_reel_l
        module procedure tenseur2_mult_tenseur2
        module procedure tenseur2_mult_vecteur
    end interface
    interface operator(/)
        module procedure tenseur2_divise_reel
        module procedure tenseur4_divise_reel
    end interface

    interface Trace
        module procedure tenseur2_trace
    end interface

    interface ContractT4T2
        module procedure tenseur4_contract2_tenseur2
    end interface

    interface Transpose
        module procedure tenseur2_transpose
    end interface

    interface BaseVecteurPropre
        module procedure tenseur2_basepropre
    end interface
    interface VersBasePrope
        module procedure passage_vers_base_propre
    end interface
    interface VersBaseInitiale
        module procedure retour_vers_base_initiale
    end interface

    interface TractionCompression
        module procedure tenseur2_TracComp
    end interface

    interface operator(.X.)
        module procedure vecteur_ptens_vecteur
    end interface
    interface ProduitTensorielVecteur
        module procedure vecteur_ptens_vecteur
    end interface

    interface TenseurVecteurAster
        module procedure tenseur_vers_vecteur_aster
    end interface
    interface VecteurAsterTenseur
        module procedure vecteur_aster_vers_tenseur
    end interface
    interface VecteurVecteurAster
        module procedure vecteur_vers_vecteur_aster
    end interface
    interface VecteurAsterVecteur
        module procedure vecteur_aster_vers_vecteur
    end interface
    interface TenseurVecteur
        module procedure tenseur_vers_vecteur
    end interface

    interface BRSigne
        module procedure signe_vecteur
    end interface

    interface Identite
        module procedure identite2
    end interface

    interface DeviaSpher
        module procedure deviateur_spherique_T2
        module procedure deviateur_spherique_Vect
    end interface
    interface TenseurDeviaSpher
        module procedure tenseur_deviateur_spherique_T2
        module procedure tenseur_deviateur_spherique_Vect
    end interface
    interface VecteurDeviaSpher
        module procedure vecteur_deviateur_spherique
    end interface

    interface Raideur
        module procedure raideur_elas
    end interface

! --------------------------------------------------------------------------------------------------
    real(kind=8), parameter :: racine2 = sqrt(2.d0)

contains

    ! ==========================================================================================
    !                                                                           Vecteur
    !
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un vecteur à partir d'un vecteur
    subroutine vecteur_vecteur(X, Y)
        !   Y = [ x, y, z ]
        type(vecteur), intent(out) :: X
        real(kind=8), intent(in), dimension(dimspace) :: Y

        X%vect = [ Y(1), Y(2), Y(3) ]
    end subroutine vecteur_vecteur
    ! ------------------------------------------------------------------------------------------
    ! Produit tensoriel de 2 vecteurs
    type(tenseur2) function vecteur_ptens_vecteur(V1,V2) result(X)
        type(vecteur),  intent(in) :: V1,V2
        integer :: ii,jj
        do ii=1, dimspace
            do jj=1, dimspace
                X%tens(ii,jj) = V1%vect(ii)*V2%vect(jj)
            enddo
        enddo
    end function vecteur_ptens_vecteur
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un vecteur à partir d'un tenseur (ordre=2) : X = Y
    function tenseur_vers_vecteur(Y) result(X)
        !       xx xy xz   1 4 5
        !   Y = xy yy yz = 4 2 6
        !       xz yz zz   5 6 3
        !
        !   X = [ xx, yy, zz, xy, xz, yz ]
        !
        type(tenseur2), intent(in)     :: Y
        real(kind=8),   dimension(1:6) :: X
        !
        X = [Y%tens(1,1), Y%tens(2,2), Y%tens(3,3), Y%tens(1,2), Y%tens(1,3), Y%tens(2,3) ]
    end function tenseur_vers_vecteur
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un vecteur de signe de Y
    function signe_vecteur(scal,Y) result(X)
        !
        real(kind=8), intent(in)  :: Y(1:6)
        real(kind=8), intent(in)  :: scal
        real(kind=8) :: X(1:6)
        integer :: ii
        !
        X = abs(scal)
        do ii=1,6
            if ( Y(ii) < 0.0d0 ) then
                X(ii) = -abs(scal)
            endif
        enddo
    end function signe_vecteur
    !
    ! ==========================================================================================
    !                                                                           Tenseur
    !
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un tenseur(ordre=2) à partir d'un vecteur : X = Y
    subroutine tenseur2_vecteur(X, Y)
#include "asterfort/assert.h"
        !   Y = [ xx, yy, zz ]
        !   Y = [ xx, yy, zz, xy, xz, yz ]
        !
        !       xx xy xz   1 4 5
        !   X = xy yy yz = 4 2 6
        !       xz yz zz   5 6 3
        type(tenseur2), intent(out) :: X
        real(kind=8), intent(in), dimension(:) :: Y
        real(kind=8), parameter :: zero = 0.0d0
        !
        if      ( size(Y,1) == dimspace ) then
            X%tens = reshape([Y(1), zero, zero, zero, Y(2), zero, zero, zero, Y(3)],[3,3])
        else if ( size(Y,1) == 2*dimspace ) then
            X%tens = reshape([Y(1), Y(4), Y(5), Y(4), Y(2), Y(6), Y(5), Y(6), Y(3)],[3,3])
        else
            write(*,*) 'Dimension vecteur <',size(Y,1),'> au lieu de ',dimspace,' ou ',dimspace*2
            ASSERT( .FALSE. )
        endif
    end subroutine tenseur2_vecteur

    ! ------------------------------------------------------------------------------------------
    ! Construction d'un vecteur à partir d'un tenseur (ordre=2) : X = Y
    subroutine vecteur_tenseur(X, Y)
#include "asterfort/assert.h"
        !
        !       xx xy xz   1 4 5
        !   Y = xy yy yz = 4 2 6
        !       xz yz zz   5 6 3
        !
        !   X = [ xx, yy, zz, xy, xz, yz ]
        !
        real(kind=8), intent(out), dimension(:) :: X
        type(tenseur2), intent(in) :: Y
        !
        if ( size(X,1) == 2*dimspace ) then
            X = [Y%tens(1,1), Y%tens(2,2), Y%tens(3,3), Y%tens(1,2), Y%tens(1,3), Y%tens(2,3) ]
        else
            write(*,*) 'Dimension vecteur <',size(X,1),'> au lieu de ',dimspace*2
            ASSERT( .FALSE. )
        endif
    end subroutine vecteur_tenseur
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un tenseur(ordre=2) à partir d'un vecteur : X = Y
    type(tenseur2) function vecteur_vers_tenseur(Y) result(X)
#include "asterfort/assert.h"
        !   Y = [ xx, yy, zz ]
        !   Y = [ xx, yy, zz, xy, xz, yz ]
        !
        !       xx xy xz   1 4 5
        !   X = xy yy yz = 4 2 6
        !       xz yz zz   5 6 3
        real(kind=8), intent(in), dimension(:) :: Y
        real(kind=8), parameter :: zero = 0.0d0
        !
        if      ( size(Y,1) == dimspace ) then
            X%tens = reshape([Y(1), zero, zero, zero, Y(2), zero, zero, zero, Y(3)],[3,3])
        else if ( size(Y,1) == 2*dimspace ) then
            X%tens = reshape([Y(1), Y(4), Y(5), Y(4), Y(2), Y(6), Y(5), Y(6), Y(3)],[3,3])
        else
            write(*,*) 'Dimension vecteur <',size(Y,1),'> au lieu de ',dimspace,' ou ',dimspace*2
            ASSERT( .FALSE. )
        endif
    end function vecteur_vers_tenseur
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un tenseur(ordre=2) à partir d'un vecteur_aster : X = Y
    type(tenseur2) function vecteur_aster_vers_tenseur(Y) result(X)
#include "asterfort/assert.h"
        !   Y = [ xx, yy, zz ]
        !   Y = [ xx, yy, zz, xy*rac2, xz*rac2, yz*rac2 ]
        !
        !       xx xy xz   1 4 5
        !   X = xy yy yz = 4 2 6
        !       xz yz zz   5 6 3
        real(kind=8), intent(in), dimension(:) :: Y
        real(kind=8), parameter :: zero = 0.0d0
        !
        if      ( size(Y,1) == dimspace ) then
            X%tens = reshape([Y(1), zero, zero, zero, Y(2), zero, zero, zero, Y(3)],[3,3])
        else if ( size(Y,1) == 2*dimspace ) then
            X%tens = reshape([Y(1),         Y(4)/racine2, Y(5)/racine2, &
                              Y(4)/racine2, Y(2),         Y(6)/racine2, &
                              Y(5)/racine2, Y(6)/racine2, Y(3)],[3,3])
        else
            write(*,*) 'Dimension vecteur <',size(Y,1),'> au lieu de ',dimspace,' ou ',dimspace*2
            ASSERT( .FALSE. )
        endif
    end function vecteur_aster_vers_tenseur
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un vecteur_aster à partir d'un tenseur (ordre=2) : X = Y
    function tenseur_vers_vecteur_aster(Y) result(X)
        !
        !       xx xy xz   1 4 5
        !   Y = xy yy yz = 4 2 6
        !       xz yz zz   5 6 3
        !
        !   X = [ xx, yy, zz, xy*rac2, xz*rac2, yz*rac2 ]
        !
        real(kind=8), dimension(1:6) :: X
        type(tenseur2), intent(in)   :: Y
        !
        X = [Y%tens(1,1),         Y%tens(2,2),         Y%tens(3,3), &
             Y%tens(1,2)*racine2, Y%tens(1,3)*racine2, Y%tens(2,3)*racine2]
    end function tenseur_vers_vecteur_aster
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un vecteur aster à partir d'un vecteur
    function vecteur_vers_vecteur_aster(Y) result(X)
        !   Y = [ xx, yy, zz, xy, xz, yz ]
        !
        !   X = [ xx, yy, zz, xy*rac2, xz*rac2, yz*rac2 ]
        !
        real(kind=8), dimension(1:6), intent(in) :: Y
        real(kind=8), dimension(1:6) :: X
        !
        X = [Y(1), Y(2), Y(3), Y(4)*racine2, Y(5)*racine2, Y(6)*racine2 ]
    end function vecteur_vers_vecteur_aster
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un vecteur à partir d'un vecteur aster
    function vecteur_aster_vers_vecteur(Y) result(X)
        !   Y = [ xx, yy, zz, xy*rac2, xz*rac2, yz*rac2 ]
        !
        !   X = [ xx, yy, zz, xy, xz, yz ]
        !
        real(kind=8), dimension(1:6), intent(in) :: Y
        real(kind=8), dimension(1:6) :: X
        !
        X = [Y(1), Y(2), Y(3), Y(4)/racine2, Y(5)/racine2, Y(6)/racine2 ]
    end function vecteur_aster_vers_vecteur
    ! ------------------------------------------------------------------------------------------
    ! Construction d'une matrice(2*dimspace,2*dimspace) à partir d'un tenseur(ordre=4) : X = Y
    ! Le tenseur doit être symétrique, la vérification doit être faite par ailleurs
    subroutine matrice_aster_tenseur4(X, Y)
#include "asterfort/assert.h"
        !
        !   Y(i,j,k,l)
        !                             a b  1     2     3     4     5     6
        !   X(a,b) = Y(i,j,k,l)           (1,1) (2,2) (3,3) (1,2) (1,3) (2,3)
        !                                                   (2,1) (3,1) (3,2)
        real(kind=8), intent(out), dimension(:,:) :: X
        type(tenseur4), intent(in) :: Y
        integer :: ii,jj,kk
        !
        if ( (size(X,1)==2*dimspace).and.(size(X,2)==2*dimspace) ) then
            do ii=1,3
                X(ii,1) = Y%tens(ii,ii,1,1)
                X(ii,2) = Y%tens(ii,ii,2,2)
                X(ii,3) = Y%tens(ii,ii,3,3)
                X(ii,4) = Y%tens(ii,ii,1,2)
                X(ii,5) = Y%tens(ii,ii,1,3)
                X(ii,6) = Y%tens(ii,ii,2,3)
            enddo
            !
            ii=4; jj=1; kk=2
            X(ii,1) = Y%tens(jj,kk,1,1)
            X(ii,2) = Y%tens(jj,kk,2,2)
            X(ii,3) = Y%tens(jj,kk,3,3)
            X(ii,4) = Y%tens(jj,kk,1,2)
            X(ii,5) = Y%tens(jj,kk,1,3)
            X(ii,6) = Y%tens(jj,kk,2,3)
            !
            ii=5; jj=1; kk=3
            X(ii,1) = Y%tens(jj,kk,1,1)
            X(ii,2) = Y%tens(jj,kk,2,2)
            X(ii,3) = Y%tens(jj,kk,3,3)
            X(ii,4) = Y%tens(jj,kk,1,2)
            X(ii,5) = Y%tens(jj,kk,1,3)
            X(ii,6) = Y%tens(jj,kk,2,3)
            !
            ii=6; jj=2; kk=3
            X(ii,1) = Y%tens(jj,kk,1,1)
            X(ii,2) = Y%tens(jj,kk,2,2)
            X(ii,3) = Y%tens(jj,kk,3,3)
            X(ii,4) = Y%tens(jj,kk,1,2)
            X(ii,5) = Y%tens(jj,kk,1,3)
            X(ii,6) = Y%tens(jj,kk,2,3)
        else
            write(*,*) 'Dimension matrice <',size(X,1),'> au lieu de ',dimspace*2
            ASSERT( .FALSE. )
        endif
    end subroutine matrice_aster_tenseur4
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un tenseur(ordre=2) à partir d'un tenseur(ordre=2) : X=Y
    subroutine tenseur2_tenseur2(X, Y)
        type(tenseur2), intent(out) :: X
        type(tenseur2), intent(in)  :: Y
        !
        X%tens = Y%tens
    end subroutine tenseur2_tenseur2
    ! ------------------------------------------------------------------------------------------
    ! Construction d'un tenseur(ordre=2) à partir d'un réel : X=Y
    subroutine tenseur2_reel(X, Y)
        type(tenseur2), intent(out) :: X
        real(kind=8),   intent(in)  :: Y
        !
        X%tens = Y
    end subroutine tenseur2_reel
    ! ------------------------------------------------------------------------------------------
    ! Trace de tenseur(ordre=2)
    real(kind=8) function tenseur2_trace(Y) result(X)
        type(tenseur2), intent(in) :: Y
        !
        X = Y%tens(1,1) + Y%tens(2,2) + Y%tens(3,3)
    end function tenseur2_trace
    ! ------------------------------------------------------------------------------------------
    ! Identité tenseur(ordre=2)
    type(tenseur2) function identite2() result(X)
        X%tens = reshape( [ 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0 ], [3,3] )
    end function identite2
    ! ------------------------------------------------------------------------------------------
    ! Déviateur tenseur(ordre=2)
    type(SpheDev) function deviateur_spherique_T2(Y) result(X)
        type(tenseur2), intent(in) :: Y
        !
        X%spherique = Trace(Y)/3.0
        X%deviateur = Y - X%spherique*Identite()
    end function deviateur_spherique_T2
    ! ------------------------------------------------------------------------------------------
    ! Tenseurs Déviateur et sphérique à partir d'un vecteur
    type(SpheDev) function deviateur_spherique_Vect(Y) result(X)
        real(kind=8), intent(in), dimension(:) :: Y
        !
        X%spherique = (Y(1) + Y(2) + Y(3))/3.0
        X%deviateur = vecteur_vers_tenseur(Y) - X%spherique*Identite()
    end function deviateur_spherique_Vect
    ! ------------------------------------------------------------------------------------------
    ! tenseur(ordre=2) à partir des tenseurs déviateur et sphérique
    type(tenseur2) function tenseur_deviateur_spherique_T2(Y) result(X)
        type(SpheDev), intent(in) :: Y
        !
        X = Y%deviateur + Y%spherique*Identite()
    end function tenseur_deviateur_spherique_T2
    ! ------------------------------------------------------------------------------------------
    ! tenseur(ordre=2) à partire des vecteurs déviateur et sphérique
    type(tenseur2) function tenseur_deviateur_spherique_Vect(Ydev,Ysph) result(X)
        real(kind=8), intent(in), dimension(:) :: Ydev
        real(kind=8), intent(in) :: Ysph
        !
        X = vecteur_vers_tenseur(Ydev) + Ysph*Identite()
    end function tenseur_deviateur_spherique_Vect
    ! ------------------------------------------------------------------------------------------
    ! vecteur à partir des vecteurs déviatorique et sphérique
    function vecteur_deviateur_spherique(Ydev,Ysph) result(X)
        real(kind=8), dimension(1:6) :: X
        real(kind=8), intent(in), dimension(:) :: Ydev
        real(kind=8), intent(in) :: Ysph
        !
        type(tenseur2) :: T2
        T2 = tenseur_deviateur_spherique_Vect(Ydev,Ysph)
        X = T2
    end function vecteur_deviateur_spherique
    !
    ! ------------------------------------------------------------------------------------------
    ! Tenseur(ordre=4) d'élasticité
    type(tenseur4) function raideur_elas(young,nu) result(X)
        real(kind=8), intent(in) :: young,nu
        real(kind=8) :: Deux_mu_plus_lambda, Deux_mu, lambda
        !
        Deux_mu_plus_lambda = (1.0-nu)/(1.0+nu)/(1.0-2.0*nu)
        Deux_mu = 1.0/(1.0+nu)
        lambda  = nu/(1.0+nu)/(1.0-2.0*nu)
        !
        X%tens(1,1,1,1) = Deux_mu_plus_lambda
        X%tens(1,1,2,2) = lambda
        X%tens(1,1,3,3) = lambda
        X%tens(2,2,1,1) = lambda
        X%tens(2,2,2,2) = Deux_mu_plus_lambda
        X%tens(2,2,3,3) = lambda
        X%tens(3,3,1,1) = lambda
        X%tens(3,3,2,2) = lambda
        X%tens(3,3,3,3) = Deux_mu_plus_lambda
        X%tens(1,2,1,2) = Deux_mu
        X%tens(1,3,1,3) = Deux_mu
        X%tens(2,3,2,3) = Deux_mu
        X%tens(2,1,2,1) = Deux_mu
        X%tens(3,1,3,1) = Deux_mu
        X%tens(3,2,3,2) = Deux_mu
        !
        X%tens = X%tens*young
    end function raideur_elas

    ! ------------------------------------------------------------------------------------------
    ! Addition de tenseur(ordre=2 et 4) : X = Y + Z
    type(tenseur2) function tenseur2_plus(Y, Z) result(X)
        type(tenseur2), intent(in) :: Y
        type(tenseur2), intent(in) :: Z
        !
        X%tens = Y%tens + Z%tens
    end function tenseur2_plus
    type(tenseur4) function tenseur4_plus(Y, Z) result(X)
        type(tenseur4), intent(in) :: Y
        type(tenseur4), intent(in) :: Z
        !
        X%tens = Y%tens + Z%tens
    end function tenseur4_plus
    ! ------------------------------------------------------------------------------------------
    ! Soustraction de tenseur(ordre=2 et 4) : X = Y - Z
    type(tenseur2) function tenseur2_moins(Y, Z) result(X)
        type(tenseur2), intent(in) :: Y
        type(tenseur2), intent(in) :: Z
        !
        X%tens = Y%tens - Z%tens
    end function tenseur2_moins
    type(tenseur4) function tenseur4_moins(Y, Z) result(X)
        type(tenseur4), intent(in) :: Y
        type(tenseur4), intent(in) :: Z
        !
        X%tens = Y%tens - Z%tens
    end function tenseur4_moins
    ! ------------------------------------------------------------------------------------------
    ! Multiplication d'un tenseur(ordre=2 et 4) par un réel à droite : X = Y * RZ
    type(tenseur2) function tenseur2_mult_reel_r(Y, RZ) result(X)
        type(tenseur2), intent(in) :: Y
        real(kind=8), intent(in) :: RZ
        !
        X%tens = Y%tens*RZ
    end function tenseur2_mult_reel_r
    type(tenseur4) function tenseur4_mult_reel_r(Y, RZ) result(X)
        type(tenseur4), intent(in) :: Y
        real(kind=8), intent(in) :: RZ
        !
        X%tens = Y%tens*RZ
    end function tenseur4_mult_reel_r
    ! Multiplication d'un tenseur(ordre=2 et 4) par un réel à gauche : X = RZ * Y
    type(tenseur2) function tenseur2_mult_reel_l(RZ, Y) result(X)
        type(tenseur2), intent(in) :: Y
        real(kind=8), intent(in) :: RZ
        !
        X%tens = Y%tens*RZ
    end function tenseur2_mult_reel_l
    type(tenseur4) function tenseur4_mult_reel_l(RZ, Y) result(X)
        type(tenseur4), intent(in) :: Y
        real(kind=8), intent(in) :: RZ
        !
        X%tens = Y%tens*RZ
    end function tenseur4_mult_reel_l
    ! ------------------------------------------------------------------------------------------
    ! Division tenseur(ordre=2 et 4) par un réel : X = Y / RZ
    type(tenseur2) function tenseur2_divise_reel(Y,RZ) result(X)
        type(tenseur2), intent(in) :: Y
        real(kind=8), intent(in) :: RZ
        !
        X%tens = Y%tens/RZ
    end function tenseur2_divise_reel
    type(tenseur4) function tenseur4_divise_reel(Y,RZ) result(X)
        type(tenseur4), intent(in) :: Y
        real(kind=8), intent(in) :: RZ
        !
        X%tens = Y%tens/RZ
    end function tenseur4_divise_reel
    ! ------------------------------------------------------------------------------------------
    ! Multiplication tenseur(ordre=2) par tenseur(ordre=2) : X = Y * Z
    type(tenseur2) function tenseur2_mult_tenseur2(Y,Z) result(X)
        type(tenseur2), intent(in) :: Y,Z
        integer :: ii,jj,kk
        !
        do ii=1, dimspace
            do jj=1,dimspace
                do kk=1, dimspace
                    X%tens(ii,jj) = X%tens(ii,jj) + Y%tens(ii,kk)*Z%tens(kk,jj)
                enddo
            enddo
        enddo
    end function tenseur2_mult_tenseur2
    ! ------------------------------------------------------------------------------------------
    ! Multiplication tenseur(ordre=2) par vecteur : VX = T2 * VY
    type(vecteur) function tenseur2_mult_vecteur(T2,VY) result(VX)
        type(tenseur2), intent(in) :: T2
        type(vecteur),  intent(in) :: VY
        integer :: ii,kk
        !
        do ii=1, dimspace
            do kk=1,dimspace
                VX%vect(ii) = VX%vect(ii) + T2%tens(ii,kk)*VY%vect(kk)
            enddo
        enddo
    end function tenseur2_mult_vecteur
    ! ------------------------------------------------------------------------------------------
    ! Produit contracté 2 fois entre tenseur(ordre=4) et tenseur(ordre=2) : X = T4::T2
    type(tenseur2) function tenseur4_contract2_tenseur2(T4,T2) result(X)
        type(tenseur4), intent(in) :: T4
        type(tenseur2), intent(in) :: T2
        integer :: ii,jj,kk,ll
        !
        do ii=1, dimspace
            do jj=1,dimspace
                do kk=1, dimspace
                    do ll=1, dimspace
                        X%tens(ii,jj) = X%tens(ii,jj) + T4%tens(ii,jj,kk,ll)*T2%tens(kk,ll)
                    enddo
                enddo
            enddo
        enddo
    end function tenseur4_contract2_tenseur2
    ! ------------------------------------------------------------------------------------------
    ! tenseur transposé d'un tenseur(ordre=2)
    type(tenseur2) function tenseur2_transpose(T2) result(X)
        type(tenseur2), intent(in) :: T2
        integer :: ii,jj

        do ii=1, dimspace
            do jj=1, dimspace
                X%tens(ii,jj) = T2%tens(jj,ii)
            enddo
        enddo
    end function tenseur2_transpose
    !
    ! ------------------------------------------------------------------------------------------
    ! Tenseur valeur propre, base propre : Méthode de Jacobi
    type(basepropre) function tenseur2_basepropre(T2,Coeff) result(X)
        type(tenseur2), intent(in) :: T2
        real(kind=8), optional, intent(in) :: Coeff
        !
        integer,parameter :: dimesym = (dimspace+1)*dimspace/2
        !
        real(kind=8) :: Nrm = 1.0D0
        real(kind=8) :: ar(dimesym), br(dimesym), jacaux(dimspace)
        real(kind=8) :: vecp(dimspace,dimspace), valep(dimspace)
        integer      :: ii
        !
        if ( present(Coeff) ) then
            Nrm = Coeff
        endif
        ! Pour jacobi : Matrice  ar = (xx xy xz yy yz zz). Partie supérieure
        ar = [T2%tens(1,1),T2%tens(1,2),T2%tens(1,3),T2%tens(2,2),T2%tens(2,3),T2%tens(3,3)]/Nrm
        ! Pour jacobi : Matrice unité. Partie supérieure
        br = [ 1.d0, 0.d0, 0.d0, 1.d0, 0.d0, 1.d0 ]
        !
        call jacobi(dimspace, ar, br, vecp, valep, jacaux)
        !
        X%valep%vect   = valep*Nrm
        X%basep%tens = vecp
        do ii = 1 , dimspace
            X%vectp(ii) = [ X%basep%tens(1,ii) , X%basep%tens(2,ii) , X%basep%tens(3,ii) ]
            X%tensp%tens(ii,ii) = X%valep%vect(ii)
        enddo
    end function tenseur2_basepropre
    !
    type(tenseur2) function passage_vers_base_propre(Basep,Tens)  result(X)
        type(basepropre) , intent(in) :: Basep
        type(tenseur2)   , intent(in) :: Tens
        !
        X = (transpose(Basep%basep)*Tens)*Basep%basep
        !
    end function passage_vers_base_propre
    !
    type(tenseur2) function retour_vers_base_initiale(Basep,Tens)  result(X)
        type(basepropre) , intent(in) :: Basep
        type(tenseur2)   , intent(in) :: Tens
        !
        X = (Basep%basep*Tens)*transpose(Basep%basep)
        !
    end function retour_vers_base_initiale
    !
    type(TracComp) function tenseur2_TracComp(Bp) result(X)
        type(basepropre) , intent(in) :: Bp
        type(tenseur2) :: Matp
        integer        :: ii
        !
        do ii = 1, dimspace
            if      ( Bp%valep%vect(ii) .gt. 0.0d0 ) then
                Matp = Bp%vectp(ii) .X. Bp%vectp(ii)
                X%traction = X%traction + Matp*Bp%valep%vect(ii)
                X%valept%vect(ii) = Bp%valep%vect(ii)
                X%istraction = .true.
            else if ( Bp%valep%vect(ii) .lt. 0.0d0 ) then
                Matp = Bp%vectp(ii) .X. Bp%vectp(ii)
                X%compress = X%compress + Matp*Bp%valep%vect(ii)
                X%valepc%vect(ii) = Bp%valep%vect(ii)
                X%iscompress = .true.
            endif
        enddo
    end function tenseur2_TracComp
    !
    real(kind=8) function Invariant1(X) result(Y)
        type(vecteur), intent(in) :: X
        Y = X%vect(1) + X%vect(2) + X%vect(3)
    end function Invariant1
    real(kind=8) function Invariant2(X) result(Y)
        type(vecteur), intent(in) :: X
        Y = ((X%vect(1)-X%vect(2))**2 +(X%vect(1)-X%vect(3))**2 +(X%vect(2)-X%vect(3))**2)/6.0d0
    end function Invariant2
    !
    subroutine jacobi(dimens, ar, br, vecpro, valpro, valaux)
        implicit none
        integer :: dimens
        real(kind=8) :: ar(1), br(1), vecpro(dimens, dimens), valpro(1)
        real(kind=8) :: valaux(1)
        !
        ! ------------------------------------------------------------------------------------------
        !
        !           VALEURS PROPRES ET VECTEURS PROPRES D'UNE MATRICE SYMÉTRIQUE
        !
        !                   DECOMPOSITION DE JACOBI GENERALISEE
        !
        ! ------------------------------------------------------------------------------------------
        !
        !   IN
        !       dimens  : dimension de la matrice
        !
        !   IN / OUT
        !       Matrices symétriques stockées sous forme d'un vecteur : a11...a1n a22...a2n
        !       Ces deux matrices sont modifiées et donc inutilisables en sortie.
        !       ar : matrice de raideur projetee
        !       br : matrice de masse projetee
        !
        !   OUT
        !       vecpro : vecteurs propres de l'itération
        !       valpro : valeurs propres de l'itération
        !
        ! ------------------------------------------------------------------------------------------
        !
        !   Routine quasi-identique à celle du Code.
        !       - différences sur les arguments d'appel
        !       - critères de précisions, dans la routine
        !       - pas de classement des valeurs propres
        !       - la routine est 'private' donc pas possible de l'appeler directement
        !       - si une autre méthode devient disponible tout doit se passer dans le module
        !
        ! ------------------------------------------------------------------------------------------
        !
        logical :: okconv
        !
        integer :: i, ii, ij, ik, im1, j, ji
        integer :: jj, jk, jm1, jp1, k, ki, kk
        integer :: km1, kp1, lji, ljk, lki, niter
        !
        real(kind=8) :: ab, aj, ajj, ak, akk, bb, bj
        real(kind=8) :: bk, ca, cg, compa, compb, d1, d2
        real(kind=8) :: den, dif, epcoma, epcomb, eps, epsa, epsb
        real(kind=8) :: eptola, eptolb, raci, rtol, verif, xj, xk
        !
        ! ------------------------------------------------------------------------------------------
        !
        ! nperm         : nombre max d'itérations de la méthode de jacobi
        integer         :: nperm = 12
        ! tol           : précision de convergence
        ! toldyn        : précision de petitesse dynamique
        real(kind=8)    :: tol=1.0d-10, toldyn=1.0d-02
        !
        ! ------------------------------------------------------------------------------------------
        !
        ii = 1
        do  i = 1, dimens
            valaux(i) = ar(ii) / br(ii)
            valpro(i) = valaux(i)
            ii = ii + dimens + 1 - i
        enddo
        !
        ! Initialisation des vecteurs propres (matrice identite)
        vecpro = 0.0d0
        do i = 1, dimens
            vecpro(i,i) = 1.0d0
        enddo
        !   Algorithme de jacobi
        niter = 0
        !
        30  continue
        !
        niter = niter + 1
        eps = (toldyn**niter)**2
        ! Boucle sur les lignes
        do j = 1, dimens - 1
            jp1 = j + 1
            jm1 = j - 1
            ljk = jm1 * dimens - jm1 * j / 2
            jj = ljk + j
            ! Boucle sur les colonnes
            kcycle: do k = jp1, dimens
                kp1 = k + 1
                km1 = k - 1
                jk = ljk + k
                kk = km1 * dimens - km1 * k / 2 + k
                ! Calcul des coefficients de la rotation
                eptola = abs( (ar(jk)*ar(jk)) )
                epcoma = abs(ar(jj)*ar(kk))*eps
                eptolb = abs( (br(jk)*br(jk)) )
                epcomb = abs(br(jj)*br(kk))*eps
                if ((eptola.eq.0.d0) .and. (eptolb.eq.0.d0)) cycle kcycle
                if ((eptola.le.epcoma) .and. (eptolb.le.epcomb)) cycle kcycle
                akk = ar(kk)*br(jk) - br(kk)*ar(jk)
                ajj = ar(jj)*br(jk) - br(jj)*ar(jk)
                ab  = ar(jj)*br(kk) - ar(kk)*br(jj)
                verif = (ab*ab + 4.0d0*akk* ajj)/4.0d0
                if (verif .ge. 0.0d0) then
                    raci = sqrt(verif)
                    d1 = ab/2.0d0 + raci
                    d2 = ab/2.0d0 - raci
                else
                    cycle kcycle
                endif
                den = d1
                if (abs(d2) .gt. abs(d1)) den = d2
                if (den .eq. 0.0d0) then
                    ca = 0.d0
                    cg = - ar(jk)/ar(kk)
                else
                    ca = akk / den
                    cg = -ajj/den
                endif
                ! Transformation des matrices de raideur et de masse
                if (dimens-2 .ne. 0) then
                    if (jm1-1 .ge. 0) then
                        do i = 1, jm1
                            im1 = i - 1
                            ij = im1 * dimens - im1 * i / 2 + j
                            ik = im1 * dimens - im1 * i / 2 + k
                            aj = ar(ij)
                            bj = br(ij)
                            ak = ar(ik)
                            bk = br(ik)
                            ar(ij) = aj + cg * ak
                            br(ij) = bj + cg * bk
                            ar(ik) = ak + ca * aj
                            br(ik) = bk + ca * bj
                        enddo
                    endif
                    if (kp1-dimens .le. 0) then
                        lji = jm1 * dimens - jm1 * j / 2
                        lki = km1 * dimens - km1 * k / 2
                        do i = kp1, dimens
                            ji = lji + i
                            ki = lki + i
                            aj = ar(ji)
                            bj = br(ji)
                            ak = ar(ki)
                            bk = br(ki)
                            ar(ji) = aj + cg * ak
                            br(ji) = bj + cg * bk
                            ar(ki) = ak + ca * aj
                            br(ki) = bk + ca * bj
                        enddo
                    endif
                    if (jp1-km1 .le. 0) then
                        lji = jm1 * dimens - jm1 * j /2
                        do i = jp1, km1
                            ji = lji + i
                            im1 = i - 1
                            ik = im1 * dimens - im1 * i / 2 + k
                            aj = ar(ji)
                            bj = br(ji)
                            ak = ar(ik)
                            bk = br(ik)
                            ar(ji) = aj + cg * ak
                            br(ji) = bj + cg * bk
                            ar(ik) = ak + ca * aj
                            br(ik) = bk + ca * bj
                        enddo
                    endif
                endif
                ak = ar(kk)
                bk = br(kk)
                ar(kk) = ak + 2.0d0 * ca * ar(jk) + ca * ca * ar(jj)
                br(kk) = bk + 2.0d0 * ca * br(jk) + ca * ca * br(jj)
                ar(jj) = ar(jj) + 2.0d0 * cg * ar(jk) + cg * cg * ak
                br(jj) = br(jj) + 2.0d0 * cg * br(jk) + cg * cg * bk
                ar(jk) = 0.0d0
                br(jk) = 0.0d0
                ! Transformation des vecteurs propres
                do i = 1, dimens
                    xj = vecpro(i,j)
                    xk = vecpro(i,k)
                    vecpro(i,j) = xj + cg * xk
                    vecpro(i,k) = xk + ca * xj
                enddo
            enddo kcycle
        enddo
        ! Calcul des nouvelles valeurs propres
        ii = 1
        do i = 1, dimens
            valpro(i) = ar(ii) / br(ii)
            ii = ii + dimens + 1 - i
        enddo
        ! Test de convergence sur les valeurs propres
        okconv = .true.
        do i = 1, dimens
            rtol = tol * valaux(i)
            dif = abs(valpro(i) - valaux(i))
            if (dif .gt. abs(rtol)) then
                okconv = .false.
                goto 9998
            endif
        enddo
        ! Calcul des facteurs de couplage et test de convergence sur ces facteurs
        eps = tol**2
        do j = 1, dimens - 1
            jm1 = j - 1
            jp1 = j + 1
            ljk = jm1 * dimens - jm1 * j /2
            jj = ljk + j
            do k = jp1, dimens
                km1 = k - 1
                jk = ljk + k
                kk = km1 * dimens - km1 * k /2 + k
                epsa = abs(ar(jk) * ar(jk))
                compa = eps * abs(ar(jj) * ar(kk))
                epsb = abs(br(jk) * br(jk))
                compb = eps * abs(br(jj) * br(kk))
                if ((epsa .ge. compa) .or. (epsb .ge. compb)) then
                    okconv = .false.
                    goto 9998
                endif
            enddo
        enddo
        !
        9998 continue
        !
        ! Si on n'a pas convergé
        if (.not.okconv) then
            ! Translation des valeurs propres
            do i = 1, dimens
                valaux(i) = valpro(i)
            enddo
            ! Test sur le nombre d'iterations
            if (niter .lt. nperm) goto 30
        endif
        ! Si convergence ou nombre max d'iterations atteint mise à jour des vecteurs propres
        ii = 1
        do i = 1, dimens
            if (br(ii) .ge. 0.0d0) then
                bb = sqrt(br(ii))
            else
                bb = -sqrt(abs(br(ii)))
            endif
            do k = 1, dimens
                vecpro(k,i) = vecpro(k,i) / bb
            enddo
            ii = ii + dimens + 1 - i
        enddo
        !
    end subroutine jacobi

end module tenseur_meca_module
