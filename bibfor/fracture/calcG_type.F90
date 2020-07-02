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
#include "asterfort/gcncon.h"

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
        character(len=24)  :: table_out = ' '
! ----- name of table G (out)
        character(len=24)  :: table_g = ' '
! ----- CARTE for behavior
        character(len=24)  :: compor = ' '
! ----- topological dimension
        integer            :: ndim      = 0
! ----- name of list of NUME
        character(len=24)  :: list_nume_name = ' '
! ----- list of nume
        integer, pointer   :: list_nume(:) => null()
! ----- number of order
        integer            :: nb_nume = 0
! ----- number option to compute
        integer            :: nb_option = 0
! ----- list of options
        character(len=8)   :: list_option(MAX_NB_OPT) = ' '
! ----- level information
        integer            :: level_info = 1
        contains
        procedure, pass    :: initialize => initialize_field
        procedure, pass    :: print      => print_field
        procedure, pass    :: isModeMeca
        procedure, pass    :: isDynaTrans
!
    end type CalcG_Field
!
!===================================================================================================
!
!===================================================================================================
!
    type CalcG_Study
! ----- name of model
        character(len=8)   :: model     = ' '
! ----- name of mesh
        character(len=8)   :: mesh      = ' '
! ----- name of material
        character(len=24)  :: material  = ' '
! ----- name of coded material
        character(len=24)  :: mateco    = ' '
! ----- name of loading
        character(len=24)  :: loading   = ' '
! ----- index order
        integer            :: nume_ordre = -1
! ----- option to compute
        character(len=8)   :: option    = ' '
! ----- member function
        contains
        procedure, pass    :: initialize => initialize_study
        procedure, pass    :: print => print_study
        procedure, pass    :: setOption
    end type CalcG_Study
!
!===================================================================================================
!
!===================================================================================================
!
    type CalcG_Theta
! ----- name of theta field
        character(len=24)       :: theta_field = ' '
! ----- number of theta field
        integer                 :: nb_theta_field = 0
! ----- name of crack
        character(len=8)        :: crack = ' '
! ----- type of crack
        character(len=24)       :: crack_type = ' '
! ----- initial configuration of the crack
        character(len=8)        :: config_init = ' '
! ----- name of the mesh (support of crack)
        character(len=8)        :: mesh = ' '
! ----- name of the nodes of the mesh (support of crack)
        character(len=24)       :: nomNoeud = ' '
! ----- coordinate of nodes of the mesh
        real(kind=8), pointer   :: coorNoeud(:) => null()
! ----- size of cell in radial direction
        real(kind=8), pointer   :: fondTailleR(:) => null()
! ----- abscisse curviligne of nodes in the crack
        real(kind=8), pointer   :: abscur(:) => null()
! ----- list of nodes in the crack
        character(len=8), pointer :: fondNoeud(:) => null()
! ----- number of nodes in the crack
        integer                 :: nb_fondNoeud = 0
! ----- xFem crack
        aster_logical           :: lxfem
! ----- type of discontinuity (for XFEM)
        character(len=16)       :: XfemDisc_type = ' '
! ----- rayon
        real(kind=8)            :: r_inf = 0.d0, r_sup = 0.d0
! ----- number of layer
        integer                 :: nb_couche_inf = 0, nb_couche_sup = 0
! ----- type of discretization
        character(len=8)        :: discretization = ' '
! ----- nubmer of nodes (for linear discretization)
        integer                 :: nb_point_fond = 0
! ----- nubmer of nodes (for legendre discretization)
        integer                 :: degree = 0
! ----- nume_fond for XFem only
        integer                 :: nume_fond = 0
! ----- the crack is closed ?
        aster_logical           :: l_closed = ASTER_FALSE
! ----- member function
        contains
        procedure, pass    :: initialize => initialize_theta
        procedure, pass    :: print => print_theta
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
#include "asterfort/cgcrio.h"
#include "asterfort/cgReadCompor.h"
#include "asterfort/dismoi.h"
#include "asterfort/gettco.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
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
        aster_logical     :: l_incr
!
        call jemarq()
!
! --- Concept de sortie (table container)
!
        call getres(this%table_out, k16bid, k16bid)
!
! --- Table pour les valeurs (table)
!
        call gcncon("_", this%table_g)
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
        if(ier == 1) then
            this%nb_option = ier
            call getvtx(' ', 'OPTION', scal=this%list_option(1))
        else
            this%nb_option = -ier
            ASSERT(this%nb_option <= MAX_NB_OPT)
            call getvtx(' ', 'OPTION', nbval=this%nb_option, vect=this%list_option)
        end if
!
! --- Level of information
!
        call infniv(ifm, this%level_info)
!
! --- List of nume
!
        this%list_nume_name = '&&OP0100.VECTORDR'
        call cgcrio(this%result_in, this%list_nume_name, this%nb_nume)
        call jeveuo(this%list_nume_name, 'L', vi=this%list_nume)
!
! --- Read <CARTE> COMPORTEMENT
!
        call cgReadCompor(this%result_in, this%compor, this%list_nume(1), l_incr)
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
        print*, "----------------------------------------------------------------------"
        print*, "Informations about CalcG_Field"
        print*, "Level of informations: ", this%level_info
        print*, "Dimension of the problem: ", this%ndim
        print*, "Result: ", this%result_in, " of type ", this%result_in_type
        print*, "Output: ", this%table_out
        print*, "Number of option to compute: ", this%nb_option
        do i =1, this%nb_option
            print*, "** option ", i, ": ", this%list_option(i)
        end do
        print*, "Number of step/mode to compute: ", this%nb_nume
        print*, "----------------------------------------------------------------------"
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    function isModeMeca(this) result(lmode)
!
    implicit none
!
        class(CalcG_Field), intent(in)  :: this
        aster_logical                   :: lmode
!
! --------------------------------------------------------------------------------------------------
!
!   The result is a MODE_MECA ?
!   In this     : calG field
! --------------------------------------------------------------------------------------------------
!
        if(this%result_in_type == "MODE_MECA") then
            lmode = ASTER_TRUE
        else
            lmode = ASTER_FALSE
        end if
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function isDynaTrans(this) result(lmode)
!
    implicit none
!
        class(CalcG_Field), intent(in)  :: this
        aster_logical                   :: lmode
!
! --------------------------------------------------------------------------------------------------
!
!   The result is a DYNA_TRANS ?
!   In this     : calG field
! --------------------------------------------------------------------------------------------------
!
        if(this%result_in_type == "DYNA_TRANS") then
            lmode = ASTER_TRUE
        else
            lmode = ASTER_FALSE
        end if
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine initialize_study(this, result_in, nume_index)
!
    implicit none
!
#include "asterfort/dismoi.h"
#include "asterfort/medomg.h"
!
        class(CalcG_Study), intent(inout)  :: this
        character(len=8), intent(in)       :: result_in
        integer, intent(in)                :: nume_index
!
! --------------------------------------------------------------------------------------------------
!
!   initialization of a CalcG_Study type
!   In this     : study type
!   In nume_index : index nume
! --------------------------------------------------------------------------------------------------
!
        this%nume_ordre = nume_index
        this%loading    = "&&STUDY.CHARGES"
        call medomg(result_in, nume_index, this%model, this%material, this%mateco, this%loading)
        call dismoi('NOM_MAILLA', this%model,'MODELE', repk=this%mesh)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine print_study(this)
!
    implicit none
!
        class(CalcG_Study), intent(in)  :: this
!
! --------------------------------------------------------------------------------------------------
!
!   print informations of a CalcG_Study type
!   In this     : study type
! --------------------------------------------------------------------------------------------------
!
        print*, "----------------------------------------------------------------------"
        print*, "Informations about CalcG_Study"
        print*, "Option: ", this%option
        print*, "Model: ", this%model
        print*, "Mesh: ", this%mesh
        print*, "Material: ", this%material
        print*, "Coded material: ", this%mateco
        print*, "Loading: ", this%loading
        print*, "Nume index: ", this%nume_ordre
        print*, "----------------------------------------------------------------------"
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine setOption(this, option)
!
    implicit none
!
        class(CalcG_Study), intent(inout)  :: this
        character(len=8), intent(in)       :: option
!
! --------------------------------------------------------------------------------------------------
!   print informations of a CalcG_Study type
!   In this     : study type
!   In option   : name of option
! --------------------------------------------------------------------------------------------------
!
        this%option = option
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
#include "asterfort/dismoi.h"
#include "asterfort/gettco.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jeexin.h"
#include "asterfort/utmess.h"
!
        class(CalcG_Theta), intent(inout)  :: this
!
! --------------------------------------------------------------------------------------------------
!
!   initialization of a CalcG_Theta type
!   In this     : theta type
! --------------------------------------------------------------------------------------------------
!
        integer :: ier, ndim
        character(len=8) :: typfon
        aster_logical :: l_disc
!
        call jemarq()
! --- get automatic name
        call gcncon("_", this%theta_field)
!
! --- get informations about the crack
!
        call getvtx('THETA', 'FISSURE', iocc=1, scal=this%crack, nbret=ier)
        ASSERT(ier==1)
        call gettco(this%crack, this%crack_type, ASTER_TRUE)
! to do - type of discotinuity if xfem
        this%lxfem = ASTER_FALSE
        ASSERT(.not.this%lxfem)
!
        if(this%lxfem) then
            call dismoi('NOM_MAILLA',this%crack,'FISS_XFEM', arret='F', repk=this%mesh)
            call dismoi('TYPE_FOND', this%crack,'FISS_XFEM', arret='F', repk=typfon)
            call dismoi('TYPE_DISCONTINUITE', this%crack, 'FISS_XFEM' , repk=this%XfemDisc_type)
            ASSERT(this%XfemDisc_type.eq.'COHESIF' .or. this%XfemDisc_type.eq.'FISSURE')
        else
            call dismoi('NOM_MAILLA',this%crack,'FOND_FISS', arret='F', repk=this%mesh)
            call dismoi('TYPE_FOND', this%crack,'FOND_FISS', arret='F', repk=typfon)
            call dismoi('CONFIG_INIT', this%crack, 'FOND_FISS', repk=this%config_init)
        end if
! --- the crack is closed ?
        if (typfon .eq. 'FERME') then
            this%l_closed = .true.
        else
            this%l_closed = .false.
        endif
! --- number of nodes in the crack
        call jelira(this%crack//'.FOND.NOEU', 'LONMAX', this%nb_fondNoeud)
!
! --- get informations about theta discretization
!
        call getvtx('THETA', 'DISCRETISATION', iocc=1, scal=this%discretization, nbret=ier)
        l_disc = (this%discretization == "LINEAIRE") .or. (this%discretization == "LEGENDRE")
        ASSERT(l_disc)
!
        call getvis('THETA', 'DEGRE', iocc=1, scal=this%degree, nbret=ier)
        call getvis('THETA', 'NB_POINT_FOND', iocc=1, scal=this%nb_point_fond, nbret=ier)
!
        if(this%discretization == "LINEAIRE") then
            ASSERT(this%nb_point_fond >= 0)
            ASSERT(this%degree == 0)
            if(this%nb_point_fond == 0) then
                this%nb_point_fond = this%nb_fondNoeud
            end if
        end if
!
        if(this%discretization == "LEGENDRE") then
            ASSERT(this%nb_point_fond == 0)
            ASSERT(this%degree >= 0)
            if(this%l_closed) then
                call utmess('F', 'RUPTURE0_90')
            end if
        end if
!
        call getvr8('THETA', 'R_INF', iocc=1, scal=this%r_inf, nbret=ier)
        call getvr8('THETA', 'R_SUP', iocc=1, scal=this%r_sup, nbret=ier)
!
        if(ier == 1 .and. ((this%r_inf < 0.d0) .or. (this%r_inf >= this%r_sup))) then
            call utmess('F', 'RUPTURE3_3', nr=2, valr=[this%r_inf, this%r_sup])
        end if
!
        call getvis('THETA', 'NB_COUCHE_INF', iocc=1, scal=this%nb_couche_inf, nbret=ier)
        call getvis('THETA', 'NB_COUCHE_SUP', iocc=1, scal=this%nb_couche_sup, nbret=ier)
!
        if(ier == 1 .and. ((this%nb_couche_inf < 0) .or. &
            (this%nb_couche_inf >= this%nb_couche_sup))) then
            call utmess('F', 'RUPTURE3_4', ni=2, vali=[this%nb_couche_inf, this%nb_couche_sup])
        end if
!
        if(this%lxfem) then
            call getvis('THETA', 'NUME_FOND', iocc=1, scal=this%nume_fond)
        end if
!
! --- Get pointers on object
!
        call jeveuo(this%mesh//'.COORDO    .VALE', 'L', vr=this%coorNoeud)
        call jeveuo(this%crack//'.FOND.TAILLE_R' , 'L', vr=this%fondTailleR)
        call jeveuo(this%crack//'.ABSCUR'        , 'L', vr=this%abscur)
        call jeveuo(this%crack//'.FOND.NOEU'     , 'L', vk8=this%fondNoeud)
!
        this%nomNoeud = this%mesh//'.NOMNOE'
!
! --- Some verification
!
        call dismoi('DIM_GEOM', this%mesh, 'MAILLAGE', repi=ndim)

        ! if(this%lxfem) then
        !     call jeexin(this%crack//'.FONDFISS', ier)
        !     ASSERT(ier.ne.0)
        !     call jeexin(this%crack//'.BASEFOND', ier)
        !     ASSERT(ier.ne.0)
        ! else
        !     call dismoi('CONFIG_INIT', this%crack, 'FOND_FISS', repk=conf)
        !     if (conf .eq. 'COLLEE') then
        !         call jeexin(this%crack//'.BASLOC', ier)
        !         ASSERT(ier.ne.0)
        !     endif
        ! end if
!
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
        print*, "----------------------------------------------------------------------"
        print*, "Informations about CalcG_Theta"
        print*, "Field theta: ", this%theta_field
        print*, "Crack: ", this%crack, " of type ", this%crack_type
        print*, "Number of nodes in the crack: ", this%nb_fondNoeud
        print*, "Mesh support: ", this%mesh
        print*, "Initial configuration: ", this%config_init
        print*, "The crack is closed ?: ", this%l_closed
        print*, "XFEM ?: ", this%lxfem, " with discontinuity: ", this%XfemDisc_type
        print*, "Discretization : ", this%discretization,  " with number/degree ", &
                this%nb_point_fond, this%degree
        print*, "Radius:"
        print*, "*** Inferior: ", this%r_inf
        print*, "*** Superior: ", this%r_sup
        print*, "Number of cell layers:"
        print*, "*** Inferior: ", this%nb_couche_inf
        print*, "*** Superior: ", this%nb_couche_sup
        print*, "----------------------------------------------------------------------"
!
    end subroutine
!
end module
