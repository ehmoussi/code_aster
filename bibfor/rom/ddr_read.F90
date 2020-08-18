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
subroutine ddr_read(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getres.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/getelem.h"
#include "asterfort/getnode.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/jeveuo.h"
#include "asterfort/romBaseGetInfo.h"
#include "asterfort/romBasePrintInfo.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDDR), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_DOMAINE_REDUIT - Initializations
!
! Read parameters
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_layer_rid , nb_layer_sub , nocc
    integer :: nb_node , nb_mail
    aster_logical :: l_corr_ef
    type(ROM_DS_Empi) :: empi_prim, empi_dual
    character(len=8)  :: base_prim, base_dual, mesh, mesh_reuse
    character(len=16) :: k16bid, answer, keywf
    character(len=24) :: grelem_rid , grnode_int , grnode_sub
    character(len=24) :: list_node, list_mail
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM19_2')
    endif
!
! - Initializations
!
    base_prim    = ' '
    base_dual    = ' '
    mesh         = ' '
    mesh_reuse   = ' '
    k16bid       = ' '
    grelem_rid   = ' '
    grnode_int   = ' '
    grnode_sub   = ' '
    list_mail    = ' '
    nb_layer_rid = 0
    nb_layer_sub = 0
    nb_node      = 0
    nb_mail      = 0
    l_corr_ef    = ASTER_FALSE
!
! - Output datastructure
!
    call getres(mesh, k16bid, k16bid)
    call getvid(' ', 'MAILLAGE', scal = mesh_reuse)
    if (mesh .ne. mesh_reuse) then
        call utmess('F', 'SUPERVIS2_79', sk='MAILLAGE')
    endif
!
! - Get parameters
!
    call getvtx(' ', 'NOM_DOMAINE'    , scal = grelem_rid)
    call getvis(' ', 'NB_COUCHE_SUPPL', scal = nb_layer_rid)
    call getvtx(' ', 'GROUP_NO_INTERF', scal = grnode_int)
    call getvtx(' ', 'CORR_COMPLET'   , scal = answer)
    l_corr_ef = answer .eq. 'OUI'
    if (l_corr_ef) then
        call getvtx(' ', 'GROUP_NO_ENCASTRE'  , scal = grnode_sub)
        call getvis(' ', 'NB_COUCHE_ENCASTRE' , scal = nb_layer_sub, nbret = nocc)
        if (nb_layer_sub .gt. nb_layer_rid) then
            call utmess('A', 'ROM4_15')
        endif
    endif
!
! - Minimum RID
!
    keywf = 'DOMAINE_MINI'
    call getfac(keywf, nocc)
    ASSERT(nocc .le. 1)
    if (nocc .eq. 1) then
        list_node = '&&OP0050.LIST_NODE'
        call getnode(mesh   , keywf, 1, ' ', list_node, nb_node)
        call jeveuo(list_node, 'L', vi = cmdPara%v_rid_mini)
        cmdPara%nb_rid_mini = nb_node
    endif
!
! - Maximum RID
!
    keywf = 'DOMAINE_MAXI'
    call getfac(keywf, nocc)
    ASSERT(nocc .le. 1)
    if (nocc .eq. 1) then
        cmdPara%l_rid_maxi = .true._1
        list_mail = '&&OP0050.LIST_MAIL'
        call getelem(mesh, keywf, 1, ' ', list_mail, nb_mail)
        call jeveuo(list_mail, 'L', vi = cmdPara%v_rid_maxi)
        cmdPara%nb_rid_maxi = nb_mail
    endif
!
! - Get informations about bases - Primal
!
    call getvid(' ', 'BASE_PRIMAL', scal = base_prim)
    call romBaseGetInfo(base_prim, empi_prim)
    call romBasePrintInfo(empi_prim)
!
! - Get informations about bases - Dual
!
    call getvid(' ', 'BASE_DUAL', scal = base_dual)
    call romBaseGetInfo(base_dual, empi_dual)
    call romBasePrintInfo(empi_dual)
!
! - Save parameters in datastructure
!
    cmdPara%mesh         = mesh
    cmdPara%grelem_rid   = grelem_rid
    cmdPara%nb_layer_rid = nb_layer_rid
    cmdPara%grnode_int   = grnode_int
    cmdPara%l_corr_ef    = l_corr_ef
    cmdPara%grnode_sub   = grnode_sub
    cmdPara%nb_layer_sub = nb_layer_sub
    cmdPara%ds_empi_prim = empi_prim
    cmdPara%ds_empi_dual = empi_dual
!
end subroutine
