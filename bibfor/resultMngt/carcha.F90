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
subroutine carcha(fieldType, fieldQuantity, fieldSupport, option, param)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(in) :: fieldType
character(len=8), intent(out) :: fieldQuantity
character(len=4), intent(out) :: fieldSupport
character(len=24), intent(out) :: option
character(len=8), intent(out) :: param
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU
!
! Get parameters for a field
!
! --------------------------------------------------------------------------------------------------
!
! In  fieldType        : type of field (DEPL, SIEF, EPSI, ...)
! Out fieldQuantity    : physical components of field (DEPL_R, SIEF_R, ...)
! Out fieldSupport     : cell support of field (NOEU, ELNO, ELEM, ...)
! Out option           : name of finite element option to manage ELGA fiels
! Out param            : name of finite element input parameter to manage ELGA fiels
!
! --------------------------------------------------------------------------------------------------
!
    option        = ' '
    param         = ' '
    fieldQuantity = ' '
    fieldSupport  = ' '

    if (fieldType .eq. 'TEMP') then
        fieldQuantity = 'TEMP_R  '
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'PRES') then
        fieldQuantity = 'PRES_R  '
        fieldSupport = 'ELEM'
    else if (fieldType.eq.'IRRA') then
        fieldQuantity = 'IRRA_R  '
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'DEPL') then
        fieldQuantity = 'DEPL_R  '
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'CONT_NOEU') then
        fieldQuantity = 'INFC_R '
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'PTOT') then
        fieldQuantity = 'DEPL_R  '
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'VITE') then
        fieldQuantity = 'DEPL_R  '
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'ACCE') then
        fieldQuantity = 'DEPL_R  '
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'FORC_NODA') then
        fieldQuantity = 'DEPL_R  '
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'REAC_NODA') then
        fieldQuantity = 'DEPL_R  '
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'SIEF_ELGA') then
        fieldQuantity = 'SIEF_R'
        fieldSupport = 'ELGA'
        option = 'RAPH_MECA'
        param = 'PCONTPR'
    else if (fieldType.eq.'SIEF_ELGA') then
        fieldQuantity = 'SIEF_R'
        fieldSupport = 'ELGA'
        option = 'SIEF_ELGA'
        param = 'PCONTPR'
    else if (fieldType.eq.'SIEQ_ELGA') then
        fieldQuantity = 'SIEF_R'
        fieldSupport = 'ELGA'
        option = 'SIEQ_ELGA'
        param = 'PCONTEQ'
    else if (fieldType.eq.'SIEF_ELNO') then
        fieldQuantity = 'SIEF_R'
        fieldSupport = 'ELNO'
        option = 'SIEF_ELNO'
        param = 'PSIEFNOR'
    else if (fieldType.eq.'SIEQ_ELNO') then
        fieldQuantity = 'SIEF_R'
        fieldSupport = 'ELNO'
        option = 'SIEQ_ELNO'
    else if (fieldType.eq.'SIEF_NOEU') then
        fieldQuantity = 'SIEF_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'SIGM_ELNO') then
        fieldQuantity = 'SIEF_R'
        fieldSupport = 'ELNO'
    else if (fieldType.eq.'SIGM_NOEU') then
        fieldQuantity = 'SIEF_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'SIEQ_NOEU') then
        fieldQuantity = 'SIEF_R'
        fieldSupport = 'NOEU'
        option = 'SIEQ_NOEU'
    else if (fieldType.eq.'EFGE_ELNO') then
        fieldQuantity = 'SIEF_R'
        fieldSupport = 'ELNO'
        option = 'EFGE_ELNO'
    else if (fieldType.eq.'EPSI_ELGA') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'ELGA'
        option = 'EPSI_ELGA'
        param = 'PDEFOPG'
    else if (fieldType.eq.'EPMQ_ELGA') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'ELGA'
        option = 'EPMQ_ELGA'
        param = 'PDEFOEQ'
    else if (fieldType.eq.'EPEQ_ELGA') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'ELGA'
        option = 'EPEQ_ELGA'
        param = 'PDEFOEQ'
    else if (fieldType.eq.'EPSG_ELGA') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'ELGA'
        option = 'EPSG_ELGA'
        param = 'PDEFOPG'
    else if (fieldType.eq.'EPSI_ELNO') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'ELNO'
        option = 'EPSI_ELNO'
        param = 'PDEFONO'
    else if (fieldType.eq.'EPSA_ELNO') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'ELNO'
        option = 'EPSI_ELNO'
        param = 'PDEFONO'
    else if (fieldType.eq.'EPSP_ELNO') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'ELNO'
        option = 'EPSP_ELNO'
        param = 'PDEFONO'
    else if (fieldType.eq.'EPSP_ELGA') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'ELGA'
        option = 'EPSP_ELGA'
        param = 'PDEFOPG'
    else if (fieldType.eq.'EPSI_NOEU') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'DIVU') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'EPSA_NOEU') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'EPME_ELNO') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'ELNO'
    else if (fieldType.eq.'EPME_NOEU') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'FLUX_NOEU') then
        fieldQuantity = 'FLUX_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'VARI_ELGA') then
        fieldQuantity = 'VARI_R'
        fieldSupport = 'ELGA'
        option = 'RAPH_MECA'
        param = 'PVARIPR'
    else if (fieldType.eq.'VARI_ELNO') then
        fieldQuantity = 'VARI_R'
        fieldSupport = 'ELNO'
        option = 'VARI_ELNO'
        param = 'PVARINR'
    else if (fieldType.eq.'VARI_NOEU') then
        fieldQuantity = 'VAR2_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'HYDR_ELNO') then
        fieldQuantity = 'HYDR_R'
        fieldSupport = 'ELNO'
    else if (fieldType.eq.'META_ELNO') then
        fieldQuantity = 'VAR2_R'
        fieldSupport = 'ELNO'
    else if (fieldType.eq.'HYDR_NOEU') then
        fieldQuantity = 'HYDR_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'ERME_ELEM') then
        fieldQuantity = 'ERRE_R'
        fieldSupport = 'ELEM'
    else if (fieldType.eq.'FSUR_3D') then
        fieldQuantity = 'FORC_R'
        fieldSupport = 'ELEM'
    else if (fieldType.eq.'T_EXT') then
        fieldQuantity = 'TEMP_R'
        fieldSupport = 'ELEM'
        option = 'CHAR_THER_TEXT_R'
        param = 'PT_EXTR'
    else if (fieldType.eq.'COEF_H') then
        fieldQuantity = 'COEH_R'
        fieldSupport = 'ELEM'
        option = 'CHAR_THER_TEXT_R'
        param = 'PCOEFHR'
    else if (fieldType.eq.'EPSG_NOEU') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'EPVC_NOEU') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'EPFP_NOEU') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'NOEU'
    else if (fieldType.eq.'EPFD_NOEU') then
        fieldQuantity = 'EPSI_R'
        fieldSupport = 'NOEU'
    else
        call utmess('F', 'RESULT2_94', sk=fieldType)
    endif
!
    if (fieldSupport .eq. 'ELGA') then
        ASSERT(option.ne.' ')
        ASSERT(param .ne.' ')
    endif
!
end subroutine
