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
module HHO_Dirichlet_module
!
use HHO_basis_module
use HHO_quadrature_module
use HHO_size_module
use HHO_type
use HHO_utils_module, only : hhoGetTypeFromModel
use HHO_eval_module, only : hhoFuncFScalEvalQp
use HHO_L2proj_module, only : hhoL2ProjFaceVec
!
implicit none
!
private
#include "asterc/indik8.h"
#include "asterf_types.h"
#include "asterfort/alcart.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/binomial.h"
#include "asterfort/calcul.h"
#include "asterfort/celces.h"
#include "asterfort/cesexi.h"
#include "asterfort/cncinv.h"
#include "asterfort/dismoi.h"
#include "asterfort/fointe.h"
#include "asterfort/getvc8.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/imprsd.h"
#include "asterfort/infniv.h"
#include "asterfort/inical.h"
#include "asterfort/ischar.h"
#include "asterfort/jelira.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/lisnch.h"
#include "asterfort/mecact.h"
#include "asterfort/megeom.h"
#include "asterfort/nocart.h"
#include "asterfort/teattr.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "blas/daxpy.h"
#include "blas/dscal.h"
#include "blas/dcopy.h"
#include "jeveux.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Module to compute the Dirichlet loads (AFFE_CHAR_CINE)
!
! --------------------------------------------------------------------------------------------------
!
    public :: hhoDiriFuncPrepare, hhoDiriFuncCompute, hhoDiriFuncApply, hhoDiriMecaProjFunc
    public :: hhoGetKinematicValues, hhoDiriReadNameFunc, hhoDiriDeca
    private :: hhoDiriNum
!
contains
!
!
!===================================================================================================
!
!===================================================================================================
!
    integer function hhoDiriNum(nb_cmp_hho_dir, nume_cmp, ndim)
!
    implicit none
!
        integer, intent(in) :: nb_cmp_hho_dir
        integer, intent(in) :: nume_cmp
        integer, intent(in) :: ndim
!
! --------------------------------------------------------------------------------------------------
!   HHO - Dirichlet loads
!
!   Determine in which dimension is composant associated to nume_ddl
!
! In nb_cmp_hho_dir  : number of componant for each direction
! In  nume_cmp  : i-th componant
! In ndim       : topological dimension of the problem
!
! --------------------------------------------------------------------------------------------------
!
        hhoDiriNum = 0
!
        if (ndim .ge. 2) then
            if ((nume_cmp >= 1) .and. nume_cmp <= (nb_cmp_hho_dir)) then
                hhoDiriNum = 1
            elseif ((nume_cmp >= nb_cmp_hho_dir + 1) .and. (nume_cmp <= 2*nb_cmp_hho_dir)) then
                hhoDiriNum = 2
            elseif (ndim == 3) then
                if ((nume_cmp >= 2*nb_cmp_hho_dir + 1) .and. (nume_cmp <= 3*nb_cmp_hho_dir)) then
                hhoDiriNum = 3
                else
                     ASSERT(ASTER_FALSE)
                end if
            else
                ASSERT(ASTER_FALSE)
            end if
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoDiriFuncPrepare(model, list_load, hhoField)
!
    implicit none
!
        character(len=24), intent(in) :: model
        character(len=19), intent(in) :: list_load
        type(HHO_Field), intent(inout):: hhoField
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Prepare fields for Dirichlet loads
!
! In model       : name of the hho model
! In  list_load  : name of datastructure for list of loads
! Out hhoField   : fields for HHO
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nume_gd, ifm, niv, nb_cmp_hho, nb_cmp_hho_max, offset
    integer :: i_cmp, ndim, elem_ndim, type_nume, i_func, nb_cine_func, nb_elem_mesh, nb_cmp_hho_dir
    character(len=8) :: name_gd, load_name, load_type, type_name, load_cine, mesh
    character(len=8), pointer :: v_field_valv(:) => null()
    character(len=8), pointer :: p_cata_nomcmp(:) => null()
    character(len=8), pointer :: v_field_ncmp(:) => null()
    character(len=19), parameter :: connex_inv = '&&HHOMEC.CONINV'
    aster_logical, pointer :: v_elem_affe(:) => null()
    integer, pointer :: v_coninv(:) => null()
    integer, pointer :: v_connex(:) => null()
    integer, pointer :: v_cata_tmdim(:) => null()
    integer, pointer :: v_coninv_longcum(:) => null()
    integer :: i_load, nb_load, ibid, elem_nume, node_nume, nb_node_elem, i_elem, i_elem_affe
    integer :: i_affe_cine, nb_affe_cine, node_nume_loc, i_node, nb_node, nume_cmp, dim_cmp
    character(len=24) :: lload_name, lload_info
    integer, pointer :: v_load_info(:) => null()
    character(len=24), pointer :: v_load_name(:) => null()
    aster_logical :: l_cine, l_func
    type(HHO_Data) :: hhoData
    integer, pointer :: v_afci(:) => null()
    character(len=8), pointer :: v_afck(:) => null()
    character(len=8), pointer :: v_afcv(:) => null()
    integer, pointer :: v_mesh_typmail(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
        call infniv(ifm, niv)
        if (niv .ge. 2) then
            call utmess('I', 'HHO2_7')
        endif
!
! ----- Initializations
!
        name_gd = 'NEUT_K8'
        call dismoi('NOM_MAILLA', model, 'MODELE', repk=mesh)
        ibid = 0
!
! ----- Get type of HHO
!
        call hhoGetTypeFromModel(model, hhoData, ndim)
        nb_cmp_hho_dir = binomial(hhoData%face_degree()+ndim-1,hhoData%face_degree())
        nb_cmp_hho = ndim * nb_cmp_hho_dir
        hhoField%nb_cmp_hho = nb_cmp_hho
        if (ndim == 3) then
            nb_cmp_hho_max = 6 * ndim
        elseif (ndim == 2) then
            nb_cmp_hho_max = 4 * ndim
        else
            ASSERT(ASTER_FALSE)
        end if
!
! ----- Read catalog
!
        call jenonu(jexnom('&CATA.GD.NOMGD', name_gd), nume_gd)
        call jeveuo(jexnum('&CATA.GD.NOMCMP', nume_gd), 'L', vk8 = p_cata_nomcmp)
!
! ----- Inverse connectivity and mesh paramters
!
        call cncinv(mesh, [ibid], 0, 'V', connex_inv)
        call jeveuo(mesh//'.TYPMAIL', 'L', vi = v_mesh_typmail)
        call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi=nb_elem_mesh)
!
! ----- Allocate <CARTE>
!
        call alcart('V', hhoField%fieldCineFunc, mesh, name_gd)
!
! ----- Acces to <CARTE>
!
        call jeveuo(hhoField%fieldCineFunc(1:19)//'.NCMP', 'E', vk8 = v_field_ncmp)
        call jeveuo(hhoField%fieldCineFunc(1:19)//'.VALV', 'E', vk8 = v_field_valv)
!
! ----- Init <CARTE>
!
        do i_cmp = 1, nb_cmp_hho_max
            v_field_ncmp(i_cmp) = p_cata_nomcmp(i_cmp)
            v_field_valv(i_cmp) = ' '
        enddo
!
! ----- Datastructure access for loads
!
        lload_name = list_load(1:19)//'.LCHA'
        lload_info = list_load(1:19)//'.INFC'
        call jeveuo(lload_name, 'E', vk24 = v_load_name)
        call jeveuo(lload_info, 'E', vi   = v_load_info)
!
! ----- Count number of kinematic loads with function
!
        call lisnch(list_load, nb_load)
        nb_cine_func = 0
        do i_load = 1, nb_load
            load_name = v_load_name(i_load)(1:8)
            l_cine    = ischar(list_load, 'DIRI', 'ELIM', i_load)
            if (l_cine) then
                call dismoi('TYPE_CHARGE', load_name, 'CHARGE', repk=load_type)
                l_func = load_type(5:6) .eq. '_F'
                if (l_func) then
                    nb_cine_func = nb_cine_func + 1
                    load_cine = load_name
                endif
            endif
        end do
!
        if (nb_cine_func .gt. 1) then
            call utmess('F','HHO2_9')
        elseif (nb_cine_func == 1) then
!
            hhoField%l_cine_f = ASTER_TRUE
!
! ----- Access to kinematic load
!
            call jeveuo(load_cine//'           .AFCK', 'L', vk8 = v_afck)
            call jeveuo(load_cine//'           .AFCI', 'L', vi  = v_afci)
            call jeveuo(load_cine//'           .AFCV', 'L', vk8 = v_afcv)
            nb_affe_cine = v_afci(1)
            ASSERT(nb_affe_cine .gt. 0)
!
! ----- Loop on kinematic values => construct informations for each element
!
            AS_ALLOCATE(vl = v_elem_affe, size = nb_elem_mesh)
            AS_ALLOCATE(vi = hhoField%v_info_cine, size = 3*nb_affe_cine)
!
            do i_affe_cine = 1, nb_affe_cine
! --------- Get current node
                node_nume = v_afci(3*(i_affe_cine-1)+2)
                nume_cmp  = v_afci(3*(i_affe_cine-1)+3)
! --------- Get elements attached to current node
                call jeveuo(jexatr(connex_inv, 'LONCUM'), 'L', vi = v_coninv_longcum)
                nb_node_elem = v_coninv_longcum(node_nume+1) - v_coninv_longcum(node_nume)
                call jeveuo(jexnum(connex_inv, node_nume), 'L', vi = v_coninv)
! --------- Loop on elements attached to current node
                do i_elem = 1, nb_node_elem
! ------------- Get current element
                    elem_nume = v_coninv(i_elem)
! ------------- Get type of element and dimension
                    type_nume = v_mesh_typmail(elem_nume)
                    call jeveuo(jexnum('&CATA.TM.TMDIM', type_nume), 'L', vi = v_cata_tmdim)
                    elem_ndim = v_cata_tmdim(1)
                    if (elem_ndim .eq. ndim) then
! ----------------- Get local index of node in element
                        call jeveuo(jexnum(mesh//'.CONNEX', elem_nume), 'L', vi=v_connex)
                        call jelira(jexnum(mesh//'.CONNEX', elem_nume), 'LONMAX', nb_node)
                        node_nume_loc = 0
                        do i_node = 1 , nb_node
                            if (v_connex(i_node) .eq. node_nume) then
                                node_nume_loc = i_node
                                exit
                            endif
                        end do
                        ASSERT(node_nume_loc .gt. 0)
                        hhoField%v_info_cine(3*(i_affe_cine-1)+1) = elem_nume
                        hhoField%v_info_cine(3*(i_affe_cine-1)+2) = node_nume_loc
                        hhoField%v_info_cine(3*(i_affe_cine-1)+3) = nume_cmp
                        v_elem_affe(elem_nume) = ASTER_TRUE
                        exit
                    endif
                end do
            end do
!
! ----- Affect values
!
            do i_elem_affe = 1, nb_elem_mesh
                elem_nume = i_elem_affe
                v_field_valv(1:nb_cmp_hho_max) = '&&FOZERO'
! ------------- Get type of element and dimension
                type_nume = v_mesh_typmail(elem_nume)
                call jeveuo(jexnum('&CATA.TM.TMDIM', type_nume), 'L', vi = v_cata_tmdim)
                elem_ndim = v_cata_tmdim(1)
                if (elem_ndim == ndim) then
                    if (v_elem_affe(i_elem_affe)) then
                        do i_affe_cine = 1, nb_affe_cine
                            if (hhoField%v_info_cine(3*(i_affe_cine-1)+1) .eq. elem_nume) then
                                node_nume_loc = hhoField%v_info_cine(3*(i_affe_cine-1)+2)
                                nume_cmp      = hhoField%v_info_cine(3*(i_affe_cine-1)+3)
                                call jenuno(jexnum('&CATA.TM.NOMTM', type_nume), type_name)
                                offset = hhoDiriDeca(type_name)
                                dim_cmp = hhoDiriNum(nb_cmp_hho_dir, nume_cmp, ndim)
                                i_func = ndim * (node_nume_loc - offset) + dim_cmp
                                v_field_valv(i_func) = v_afcv(i_affe_cine)
                            endif
                        end do
                    end if
                call nocart(hhoField%fieldCineFunc, 3, nb_cmp_hho_max, mode = 'NUM', nma = 1,&
                                limanu = [elem_nume])
                end if
            end do
!
            if (niv .ge. 2) then
                call imprsd('CHAMP', hhoField%fieldCineFunc, 6, 'Carte fonctions pour Dirichlet')
            endif
!
            AS_DEALLOCATE(vl = v_elem_affe)
        else
            hhoField%l_cine_f = ASTER_FALSE
        endif
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoDiriFuncApply(hhoField, i_affe_cine, res)
!
    implicit none
!
        type(HHO_Field), intent(in)   :: hhoField
        integer, intent(in) :: i_affe_cine
        real(kind=8) :: res
!
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Apply Dirichlet loads
!
! In hhoField    : fields for hho
! In i_affe_cine : i-th affe_char_cine equation
! Out res        : value of the i-th affe_char_cine equation
!
! --------------------------------------------------------------------------------------------------
!
        character(len=24), parameter :: cesVale = '&&HHOMECA_VALS'
        character(len=24) :: celVale
        integer :: elem_nume, node_nume_loc, nume_cmp
        integer :: jv_cesd, jv_cesl, jv_cesv, iad
!
! --------------------------------------------------------------------------------------------------
!
        res        = 0.d0
        celVale    = hhoField%fieldCineVale
!
! ----- Get information about kinematic load
!
        elem_nume     = hhoField%v_info_cine(3*(i_affe_cine-1)+1)
        node_nume_loc = hhoField%v_info_cine(3*(i_affe_cine-1)+2)
        nume_cmp      = hhoField%v_info_cine(3*(i_affe_cine-1)+3)
!
! ----- Convert to CHAM_ELEM_S
!
        call celces(celVale, 'V', cesVale)
!
! ----- Access to CHAM_ELEM_S
!
        call jeveuo(cesVale(1:19)//'.CESD', 'L', jv_cesd)
        call jeveuo(cesVale(1:19)//'.CESL', 'E', jv_cesl)
        call jeveuo(cesVale(1:19)//'.CESV', 'E', jv_cesv)
!
! ----- Get value
!
        call cesexi('S', jv_cesd, jv_cesl, elem_nume, node_nume_loc, 1, nume_cmp, iad)
        ASSERT(iad .gt. 0)
        res = zr(jv_cesv-1+iad)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoDiriFuncCompute(model, hhoField, time_curr)
!
    implicit none
!
        character(len=24), intent(in) :: model
        type(HHO_Field), intent(in)   :: hhoField
        real(kind=8), intent(in) :: time_curr
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Evaluation of function for DIrichlet loads
!
! In  model            : name of model
! In  hhoField         : fields for HHO
! In  time_curr        : current time
!
! --------------------------------------------------------------------------------------------------
!
        integer :: ifm, niv
        character(len=16) :: option
        character(len=19) :: ligrel_model
        character(len=1) :: base
        integer, parameter :: nbin = 3
        integer, parameter :: nbout = 1
        character(len=8) :: lpain(nbin), lpaout(nbout)
        character(len=19) :: lchin(nbin), lchout(nbout)
        character(len=24) :: chgeom, chtime
        character(len=8), parameter :: cmp_name(1) = (/'INST'/)
!
! --------------------------------------------------------------------------------------------------
!
        call infniv(ifm, niv)
        if (niv .ge. 2) then
            call utmess('I', 'HHO2_6')
        endif
!
! --- Initializations
!
        base         = 'V'
        option       = 'HHO_CINE_F_MECA'
        chtime       = '&&HHOCHTIME'
        ligrel_model = model(1:8)//'.MODELE'
!
! --- Init fields
!
        call inical(nbin, lpain, lchin, nbout, lpaout, lchout)
!
! --- Geometry field
!
        call megeom(model, chgeom)
!
! --- Time field
!
        call mecact('V', chtime, 'LIGREL', ligrel_model, 'INST_R  ',&
                    ncmp=1, nomcmp=cmp_name(1), sr=time_curr)
!
! --- Input fields
!
        lpain(1) = 'PGEOMER'
        lchin(1) = chgeom(1:19)
        lpain(2) = 'PINSTPR'
        lchin(2) = chtime(1:19)
        lpain(3) = 'PFONC'
        lchin(3) = hhoField%fieldCineFunc(1:19)
!
! --- Output fields
!
        lpaout(1) = 'PCINE'
        lchout(1) = hhoField%fieldCineVale(1:19)
!
! --- Compute
!
        call calcul('S'  , option, ligrel_model, nbin  , lchin,&
                    lpain, nbout , lchout      , lpaout, base ,&
                    'OUI')
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGetKinematicValues(keywordFact, ioc        ,&
                                    model      , nogdsi     , valeType,&
                                    userDOFNb  , userDOFName,&
                                    cnuddl     , cvlddl     , nbddl)
!
    implicit none
!

!
        character(len=16), intent(in)   :: keywordFact
        integer, intent(in)             :: ioc
        character(len=8), intent(in)    :: nogdsi, model
        character(len=1), intent(in)    :: valeType
        integer, intent(in)             :: userDOFNb
        character(len=16), intent(in)   :: userDOFName(*)
        character(len=24), intent(out)  :: cnuddl, cvlddl
        integer, intent(out)            :: nbddl
!
! --------------------------------------------------------------------------------------------------
!
! AFFE_CHAR_CINE
!
! Get kinematic values for HHO
!
! --------------------------------------------------------------------------------------------------
!
        integer :: idnddl, idvddl, jcmp
        integer :: iddl, i, nbcmp, ila, icmp, userDOFNbSupp, ndim
        character(len=16) :: currentDOF
        real(kind=8) :: valeDOF
        character(len=2) :: typeJEVEUX
        type(HHO_Data) :: hhoData
        character(len=8) :: nomFunc
        character(len=16), parameter :: motcle(5) = (/ 'GROUP_MA', 'MAILLE  ',&
                                                    'GROUP_NO', 'NOEUD   ',&
                                                    'TOUT    '/)
        integer, parameter :: nbCmpSupp = 6
!
! --------------------------------------------------------------------------------------------------
!
        nbddl  = 0
        cnuddl = '&&CHARCI.NUMDDL'
        cvlddl = '&&CHARCI.VALDDL'
!
! --- Access to FE catalog
!
        call jeveuo(jexnom('&CATA.GD.NOMCMP', nogdsi), 'L', jcmp)
        call jelira(jexnom('&CATA.GD.NOMCMP', nogdsi), 'LONMAX', nbcmp)
!
! --- Get type of HHO
!
        call hhoGetTypeFromModel(model, hhoData, ndim)
!
! - Create objects
!
        userDOFNbSupp = userDOFNb * nbCmpSupp
        call wkvect(cnuddl, ' V V K8', userDOFNbSupp, idnddl)
!
! - Select type
!
        if (valeType .eq. 'R') then
            typeJEVEUX = 'R'
        elseif (valeType .eq. 'F') then
            typeJEVEUX = 'K8'
        else
            ASSERT(ASTER_FALSE)
        endif
!
        call wkvect(cvlddl, ' V V '//typeJEVEUX, userDOFNbSupp, idvddl)
!
! --- Read values
!
        do iddl = 1, userDOFNb
            currentDOF = userDOFName(iddl)
            do i = 1, 5
                if (currentDOF .eq. motcle(i)) goto 110
            end do
! ----- Verification que la composante existe dans la grandeur
            icmp = indik8( zk8(jcmp), currentDOF(1:8), 1, nbcmp )
            ASSERT(icmp .ne. 0)
!
            if (valeType .eq. 'R') then
                call getvr8(keywordFact, currentDOF, iocc=ioc, scal=valeDOF, nbret=ila)
            elseif (valeType .eq. 'F') then
                call getvid(keywordFact, currentDOF, iocc=ioc, scal=nomFunc, nbret=ila)
            else
                ASSERT(ASTER_FALSE)
            end if
!
            if (currentDOF(1:3) == "HHO") then
                ASSERT(valeType .eq. 'R')
                nbddl = nbddl + 1
                zk8(idnddl+nbddl-1) = currentDOF(1:8)
                zr(idvddl+nbddl-1)  = valeDOF
                go to 110
            end if
!
            if (hhoData%face_degree() .ge. 0) then
                nbddl = nbddl + 1
                if (currentDOF .eq. 'DX') then
                    zk8(idnddl+nbddl-1) = 'HHO_U1'
                elseif (currentDOF .eq. 'DY') then
                    zk8(idnddl+nbddl-1) = 'HHO_V1'
                elseif (currentDOF .eq. 'DZ') then
                    if(ndim .ne. 3) then
                        call utmess('F', 'CHARGES_57')
                    end if
                    zk8(idnddl+nbddl-1) = 'HHO_W1'
                elseif (currentDOF .eq. 'TEMP') then
                    zk8(idnddl+nbddl-1) = 'HHO1'
                else
                    ASSERT(ASTER_FALSE)
                endif
!
                if (valeType .eq. 'R') then
                    zr(idvddl+nbddl-1)  = valeDOF
                elseif (valeType .eq. 'F') then
                    ASSERT(currentDOF(1:3) .ne. 'HHO')
                    zk8(idvddl+nbddl-1) = nomFunc
                else
                    ASSERT(ASTER_FALSE)
                end if
!
            end if
!
            if (hhoData%face_degree() .ge. 1) then
                if(ndim == 2) then
                    nbddl = nbddl + 1
                    if (currentDOF .eq. 'DX') then
                        zk8(idnddl+nbddl-1) = 'HHO_U2'
                    elseif (currentDOF .eq. 'DY') then
                        zk8(idnddl+nbddl-1) = 'HHO_V2'
                    elseif (currentDOF .eq. 'TEMP') then
                        zk8(idnddl+nbddl-1) = 'HHO2'
                    else
                        ASSERT(ASTER_FALSE)
                    endif
!
                    if (valeType .eq. 'R') then
                        zr(idvddl+nbddl-1)  = 0.d0
                    elseif (valeType .eq. 'F') then
                        zk8(idvddl+nbddl-1) = nomFunc
                    else
                        ASSERT(ASTER_FALSE)
                    end if
!
                else if(ndim == 3) then
                    nbddl = nbddl + 1
                    if (currentDOF .eq. 'DX') then
                        zk8(idnddl+nbddl-1) = 'HHO_U2'
                    elseif (currentDOF .eq. 'DY') then
                        zk8(idnddl+nbddl-1) = 'HHO_V2'
                    elseif (currentDOF .eq. 'DZ') then
                        zk8(idnddl+nbddl-1) = 'HHO_W2'
                    elseif (currentDOF .eq. 'TEMP') then
                        zk8(idnddl+nbddl-1) = 'HHO2'
                    else
                        ASSERT(ASTER_FALSE)
                    endif
!
                    if (valeType .eq. 'R') then
                        zr(idvddl+nbddl-1)  = 0.d0
                    elseif (valeType .eq. 'F') then
                        zk8(idvddl+nbddl-1) = nomFunc
                    else
                        ASSERT(ASTER_FALSE)
                    end if
!
                    nbddl = nbddl + 1
                    if (currentDOF .eq. 'DX') then
                        zk8(idnddl+nbddl-1) = 'HHO_U3'
                    elseif (currentDOF .eq. 'DY') then
                        zk8(idnddl+nbddl-1) = 'HHO_V3'
                    elseif (currentDOF .eq. 'DZ') then
                        zk8(idnddl+nbddl-1) = 'HHO_W3'
                    elseif (currentDOF .eq. 'TEMP') then
                        zk8(idnddl+nbddl-1) = 'HHO3'
                    else
                        ASSERT(ASTER_FALSE)
                    endif
!
                    if (valeType .eq. 'R') then
                        zr(idvddl+nbddl-1)  = 0.d0
                    elseif (valeType .eq. 'F') then
                        zk8(idvddl+nbddl-1) = nomFunc
                    else
                        ASSERT(ASTER_FALSE)
                    end if
                else
                        ASSERT(ASTER_FALSE)
                end if
            end if
!
            if (hhoData%face_degree() .eq. 2) then
                if(ndim == 2) then
                    nbddl = nbddl + 1
                    if (currentDOF .eq. 'DX') then
                        zk8(idnddl+nbddl-1) = 'HHO_U3'
                    elseif (currentDOF .eq. 'DY') then
                        zk8(idnddl+nbddl-1) = 'HHO_V3'
                    elseif (currentDOF .eq. 'TEMP') then
                        zk8(idnddl+nbddl-1) = 'HHO3'
                    else
                        ASSERT(ASTER_FALSE)
                    endif
!
                    if (valeType .eq. 'R') then
                        zr(idvddl+nbddl-1)  = 0.d0
                    elseif (valeType .eq. 'F') then
                        zk8(idvddl+nbddl-1) = nomFunc
                    else
                    ASSERT(ASTER_FALSE)
                        end if
!
                elseif (ndim == 3) then
                    nbddl = nbddl + 1
                    if (currentDOF .eq. 'DX') then
                        zk8(idnddl+nbddl-1) = 'HHO_U4'
                    elseif (currentDOF .eq. 'DY') then
                        zk8(idnddl+nbddl-1) = 'HHO_V4'
                    elseif (currentDOF .eq. 'DZ') then
                        zk8(idnddl+nbddl-1) = 'HHO_W4'
                    elseif (currentDOF .eq. 'TEMP') then
                        zk8(idnddl+nbddl-1) = 'HHO4'
                    else
                        ASSERT(ASTER_FALSE)
                    endif
!
                    if (valeType .eq. 'R') then
                        zr(idvddl+nbddl-1)  = 0.d0
                    elseif (valeType .eq. 'F') then
                        zk8(idvddl+nbddl-1) = nomFunc
                    else
                        ASSERT(ASTER_FALSE)
                    end if
!
                    nbddl = nbddl + 1
                    if (currentDOF .eq. 'DX') then
                        zk8(idnddl+nbddl-1) = 'HHO_U5'
                    elseif (currentDOF .eq. 'DY') then
                        zk8(idnddl+nbddl-1) = 'HHO_V5'
                    elseif (currentDOF .eq. 'DZ') then
                        zk8(idnddl+nbddl-1) = 'HHO_W5'
                    elseif (currentDOF .eq. 'TEMP') then
                        zk8(idnddl+nbddl-1) = 'HHO5'
                    else
                        ASSERT(ASTER_FALSE)
                    endif
!
                    if (valeType .eq. 'R') then
                        zr(idvddl+nbddl-1)  = 0.d0
                    elseif (valeType .eq. 'F') then
                        zk8(idvddl+nbddl-1) = nomFunc
                    else
                        ASSERT(ASTER_FALSE)
                    end if
!
                    nbddl = nbddl + 1
                    if (currentDOF .eq. 'DX') then
                        zk8(idnddl+nbddl-1) = 'HHO_U6'
                    elseif (currentDOF .eq. 'DY') then
                        zk8(idnddl+nbddl-1) = 'HHO_V6'
                    elseif (currentDOF .eq. 'DZ') then
                        zk8(idnddl+nbddl-1) = 'HHO_W6'
                    elseif (currentDOF .eq. 'TEMP') then
                        zk8(idnddl+nbddl-1) = 'HHO6'
                    else
                        ASSERT(ASTER_FALSE)
                    endif
!
                    if (valeType .eq. 'R') then
                        zr(idvddl+nbddl-1)  = 0.d0
                    elseif (valeType .eq. 'F') then
                        zk8(idvddl+nbddl-1) = nomFunc
                    else
                        ASSERT(ASTER_FALSE)
                    end if
                else
                        ASSERT(ASTER_FALSE)
                end if
!
            elseif(hhoData%face_degree() .ge. 3) then
                ASSERT(ASTER_FALSE)
            endif
110 continue
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoDiriReadNameFunc(hhoCell, v_func, nomFunc)
!
    implicit none
!
        type(HHO_Cell), intent(in)   :: hhoCell
        character(len=8), intent(in) :: v_func(*)
        character(len=8), intent(out):: nomFunc(3,6)
!
! --------------------------------------------------------------------------------------------------
!   HHO - AFFE_CHAR_CINE_F
!
!   Read Dirichlet loads
!
!   In hhoCell         : a HHO Cell
!   In v_func          : pointer to name of the function
!   Out nomFunc        : table with the name of the function
!
! --------------------------------------------------------------------------------------------------
!
        integer :: idim, iFace, ind
!
! --------------------------------------------------------------------------------------------------
!
! --- Initialisation
!
        nomFunc = '&&FOZERO'
!
        ind = 1
        do iFace = 1, hhoCell%nbfaces
            do idim = 1, hhoCell%ndim
                nomFunc(idim, iFace) = v_func(ind)
                ind = ind + 1
            end do
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoDiriMecaProjFunc(hhoCell, hhoData, nomFunc, time, rhs_cine)
!
    implicit none
!
        type(HHO_Cell), intent(in)   :: hhoCell
        type(HHO_Data), intent(in)   :: hhoData
        character(len=8), intent(in) :: nomFunc(3,6)
        real(kind=8), intent(in)     :: time
        real(kind=8), intent(out)    :: rhs_cine(MSIZE_FDOFS_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO - AFFE_CHAR_CINE_F
!
!   Read Dirichlet loads
!
!   In hhoCell         : a HHO Cell
!   In hhoData         : information on HHO methods
!   In v_func          : pointer to name of the function
!   Out nomFunc        : table with the name of the function
!
! --------------------------------------------------------------------------------------------------
!
        integer, parameter :: maxpara = 4
        real(kind=8) :: valpar(maxpara)
        character(len=8) :: nompar(maxpara)
        type(HHO_Face) :: hhoFace
        type(HHO_Quadrature) :: hhoQuadFace
        integer :: cbs, fbs, total_dofs, idim, iFace, nbpara, ind
        real(kind=8) :: FuncValuesQP(3, MAX_QP_FACE)
!
! --------------------------------------------------------------------------------------------------
!
! --- Initialisation
!
        rhs_cine = 0.d0
!
        call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
!
! --- Type of function dor a face
!
        if (hhoCell%ndim == 3) then
            nbpara = 4
            nompar(1:3) = (/ 'X', 'Y', 'Z' /)
            nompar(nbpara) = 'INST'
            valpar(nbpara) = time
        else if (hhoCell%ndim == 2) then
            nbpara = 3
            nompar(1:2) = (/ 'X', 'Y' /)
            nompar(nbpara) = 'INST'
            valpar(nbpara) = time
            nompar(4) = 'XXXXXXXX'
            valpar(4) = 0.d0
        else
            ASSERT(ASTER_FALSE)
        end if
!
! --- Loop on faces
!
        ind = 1
        do iFace = 1, hhoCell%nbfaces
            hhoFace = hhoCell%faces(iFace)
!
! ----- get quadrature
!
            call hhoQuadFace%GetQuadFace(hhoface, 2 * hhoData%face_degree() + 2)
!
! --- Loop on directions
!
            do idim = 1, hhoCell%ndim
                if(nomFunc(idim, iFace) .ne. '&&FOZERO') then
!
! -------------- Value of the function at the quadrature point
!
                    call hhoFuncFScalEvalQp(hhoQuadFace, nomFunc(idim, iFace), nbpara, nompar,&
                                            valpar, hhoCell%ndim, FuncValuesQp(idim,1:MAX_QP_FACE))
!
                end if
            end do
!
! -------------- Compute L2 projection
!
            call hhoL2ProjFaceVec(hhoFace, hhoQuadFace, FuncValuesQP, hhoData%face_degree(), &
                                 rhs_cine(ind))
            ind = ind + fbs
        end do
!
    end subroutine
!
!
!===================================================================================================
!
!===================================================================================================
!
    integer function hhoDiriDeca(typema)
!
    implicit none
!
        character(len=8), intent(in), optional :: typema
!
! --------------------------------------------------------------------------------------------------
!   HHO - AFFE_CHAR_CINE_F
!
!   Find the offset to save the projection
!
!   In (opt) typema : type of element
! --------------------------------------------------------------------------------------------------
!
        integer :: iret
        character(len=8) :: typma2
!
! --------------------------------------------------------------------------------------------------
!
! ---  Get type of element
!
        if(present(typema)) then
            typma2 = typema
        else
            call teattr('S', 'TYPMA', typma2, iret)
            ASSERT(iret == 0)
        endif
!
        if(typma2 == 'H27' .or. typma2 == 'HEXA27') then
            hhoDiriDeca = 21
        elseif(typma2 == 'QU8' .or. typma2 == 'QUAD8') then
            hhoDiriDeca = 5
        elseif(typma2 == 'QU9' .or. typma2 == 'QUAD9') then
            hhoDiriDeca = 5
        elseif(typma2 == 'TR6' .or. typma2 == 'TRIA6') then
            hhoDiriDeca = 4
        elseif(typma2 == 'TR7' .or. typma2 == 'TRIA7') then
            hhoDiriDeca = 4
        elseif(typma2 == 'TE8' .or. typma2 == 'TETRA8') then
            hhoDiriDeca = 5
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end function
!
end module
