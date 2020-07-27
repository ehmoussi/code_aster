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
! aslint: disable=W1502
!
subroutine rscrsd(baseZ, resultNameZ, resultTypeZ, nbStore)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/utpara.h"
#include "asterfort/wkvect.h"
!
character(len=*), intent(in) :: baseZ, resultNameZ, resultTypeZ
integer, intent(in) :: nbStore
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Create result datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : JEVEUX base to create datastructure
! In  resultName       : name of input results datastructure
! In  resultType       : type of results datastructure
! In  nbStore          : number of storing index
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iField, iNova, iret, jvDummy
    integer :: nbField, nbNova
    character(len=1) :: base
    character(len=16) :: resultType
    character(len=19) :: resultName
!
! --------------------------------------------------------------------------------------------------
!

!     ------------------------------------------------------------------
!                      For thermic
!     ------------------------------------------------------------------
    integer, parameter :: nbFieldTher = 18
    character(len=16), parameter :: fieldTher(nbFieldTher) = (/&
        'TEMP            ',&
        'FLUX_ELGA       ', 'FLUX_ELNO       ', 'FLUX_NOEU       ',&
        'META_ELNO       ', 'META_NOEU       ',&
        'DURT_ELNO       ', 'DURT_NOEU       ', 'ETHE_ELEM       ',&
        'HYDR_ELNO       ', 'HYDR_NOEU       ',&
        'SOUR_ELGA       ', 'COMPORTHER      ', 'COMPORMETA      ',&
        'ERTH_ELEM       ', 'ERTH_ELNO       ', 'ERTH_NOEU       ',&
        'TEMP_ELGA       '/)

!     ------------------------------------------------------------------
!                      For external state variables
!     ------------------------------------------------------------------
    integer, parameter :: nbFieldVarc = 9
    character(len=16), parameter :: fieldVarc(nbFieldVarc) = (/&
        'IRRA            ', 'TEMP            ', 'HYDR_ELNO       ',&
        'HYDR_NOEU       ', 'EPSA_ELNO       ', 'META_ELNO       ',&
        'PTOT            ', 'DIVU            ', 'NEUT            '/)

!     ------------------------------------------------------------------
!                      For acoustic (transient)
!     ------------------------------------------------------------------
    integer, parameter :: nbFieldAcou = 5
    character(len=16), parameter :: fieldAcou(nbFieldAcou) = (/&
        'PRES            ', 'PRAC_ELNO       ', 'PRAC_NOEU       ',&
        'INTE_ELNO       ', 'INTE_NOEU       '/)

!     ------------------------------------------------------------------
!                      For acoustic (modal)
!     ------------------------------------------------------------------
    integer, parameter :: nbFieldMoac = 1
    character(len=16), parameter :: fieldMoac(nbFieldMoac) = (/&
        'PRES            '/)

!     ------------------------------------------------------------------
!                      For reduced mode
!     ------------------------------------------------------------------
    integer, parameter :: nbFieldRom = 5
    character(len=16), parameter :: fieldRom(nbFieldRom) = (/&
        'TEMP            ',&
        'DEPL            ',&
        'FLUX_NOEU       ',&
        'SIEF_NOEU       ',&
        'SIEF_ELGA       '/)

!     ------------------------------------------------------------------
!                      For mechanic
!     ------------------------------------------------------------------
    integer, parameter :: nbFieldMeca = 128
    character(len=16), parameter :: fieldMeca(nbFieldMeca) = (/&
        'DEPL            ', 'VITE            ', 'ACCE            ',&
        'DEPL_ABSOLU     ', 'VITE_ABSOLU     ', 'ACCE_ABSOLU     ',&
        'EFGE_ELNO       ', 'EFGE_NOEU       ',&
        'EPSI_ELGA       ', 'EPSI_ELNO       ',&
        'EPSI_NOEU       ', 'SIEF_ELGA       ',&
        'SIGM_ELGA       ', 'EFGE_ELGA       ',&
        'SIEF_ELNO       ', 'SIEF_NOEU       ', 'SIGM_ELNO       ',&
        'SIGM_NOEU       ', 'SIZ1_NOEU       ', 'SIZ2_NOEU       ',&
        'SIPO_ELNO       ', 'SIPO_NOEU       ',&
        'SIEQ_ELGA       ', 'SIEQ_ELNO       ', 'SIEQ_NOEU       ',&
        'EPEQ_ELGA       ', 'EPEQ_ELNO       ', 'EPEQ_NOEU       ',&
        'SIRO_ELEM       ', 'FLHN_ELGA       ',&
        'SIPM_ELNO       ', 'STRX_ELGA       ', 'FORC_EXTE       ',&
        'FORC_AMOR       ', 'FORC_LIAI       ',&
        'EPGQ_ELGA       ', 'EPGQ_ELNO       ', 'EPGQ_NOEU       ',&
        'DEGE_ELNO       ', 'DEGE_NOEU       ', 'DEGE_ELGA       ',&
        'EPOT_ELEM       ',&
        'ECIN_ELEM       ', 'FORC_NODA       ', 'REAC_NODA       ',&
        'ERME_ELEM       ', 'ERME_ELNO       ', 'ERME_NOEU       ',&
        'ERZ1_ELEM       ', 'ERZ2_ELEM       ', 'QIRE_ELEM       ',&
        'QIRE_ELNO       ', 'QIRE_NOEU       ', 'QIZ1_ELEM       ',&
        'QIZ2_ELEM       ', 'EPSG_ELGA       ', 'EPSG_ELNO       ',&
        'EPSG_NOEU       ', 'EPSP_ELGA       ', 'EPSP_ELNO       ',&
        'EPSP_NOEU       ', 'VARI_ELGA       ',&
        'VARI_NOEU       ', 'VARI_ELNO       ',&
        'EPSA_ELNO       ', 'EPSA_NOEU       ',&
        'COMPORTEMENT    ', 'DERA_ELGA       ', 'DERA_ELNO       ',&
        'DERA_NOEU       ', 'PRME_ELNO       ', 'EPME_NOEU       ',&
        'EPME_ELNO       ', 'EPME_ELGA       ', 'EPMG_ELNO       ',&
        'EPMG_ELGA       ', 'ENEL_ELGA       ', 'ENEL_ELNO       ',&
        'ENEL_NOEU       ', 'ENEL_ELEM       ', 'ENTR_ELEM       ',&
        'EPMG_NOEU       ', 'SING_ELEM       ', 'SING_ELNO       ',&
        'DISS_ELGA       ', 'DISS_ELNO       ', 'DISS_NOEU       ',&
        'DISS_ELEM       ', 'EPSL_ELGA       ', 'EPSL_ELNO       ',&
        'EPSL_NOEU       ',&
        'EPMQ_ELGA       ', 'EPMQ_ELNO       ', 'EPMQ_NOEU       ',&
        'EPFP_ELNO       ', 'EPFP_ELGA       ',&
        'EPFD_ELNO       ', 'EPFD_ELGA       ',&
        'EPVC_ELNO       ', 'EPVC_ELGA       ', 'CONT_NOEU       ',&
        'ETOT_ELGA       ', 'ETOT_ELNO       ', 'ETOT_ELEM       ',&
        'ETOT_NOEU       ', 'CONT_ELEM       ',&
        'ENDO_ELGA       ', 'ENDO_ELNO       ', 'ENDO_NOEU       ',&
        'INDL_ELGA       ', 'VAEX_ELGA       ', 'VAEX_ELNO       ',&
        'VAEX_NOEU       ', 'SISE_ELNO       ',&
        'COHE_ELEM       ', 'INDC_ELEM       ', 'SECO_ELEM       ',&
        'VARC_ELGA       ', 'FERRAILLAGE     ', 'EPVC_NOEU       ',&
        'EPFD_NOEU       ', 'EPFP_NOEU       ', 'PDIL_ELGA       ',&
        'MATE_ELGA       ', 'MATE_ELEM       ', 'HHO_CELL        ',&
        'HHO_FACE        ', 'PRES_NOEU       '/)

!     ------------------------------------------------------------------
!                      For loads (EVOl_CHAR)
!     ------------------------------------------------------------------
    integer, parameter :: nbFieldChar = 10
    character(len=16), parameter :: fieldChar(nbFieldChar) = (/&
        'FORC_NODA       ', 'PRES            ',&
        'FVOL_3D         ', 'FVOL_2D         ',&
        'FSUR_3D         ', 'FSUR_2D         ',&
        'VITE_VENT       ', 'T_EXT           ',&
        'COEF_H          ', 'FLUN            '/)

!     ------------------------------------------------------------------
!                      For keyword UTIL in CALC_CHAMP
!     ------------------------------------------------------------------
    integer, parameter :: nbFieldUtil = 40
    character(len=16), parameter :: fieldUtil(nbFieldUtil) = (/&
        'UT01_ELGA       ', 'UT01_ELNO       ', 'UT01_ELEM       ', 'UT01_NOEU       ',&
        'UT02_ELGA       ', 'UT02_ELNO       ', 'UT02_ELEM       ', 'UT02_NOEU       ',&
        'UT03_ELGA       ', 'UT03_ELNO       ', 'UT03_ELEM       ', 'UT03_NOEU       ',&
        'UT04_ELGA       ', 'UT04_ELNO       ', 'UT04_ELEM       ', 'UT04_NOEU       ',&
        'UT05_ELGA       ', 'UT05_ELNO       ', 'UT05_ELEM       ', 'UT05_NOEU       ',&
        'UT06_ELGA       ', 'UT06_ELNO       ', 'UT06_ELEM       ', 'UT06_NOEU       ',&
        'UT07_ELGA       ', 'UT07_ELNO       ', 'UT07_ELEM       ', 'UT07_NOEU       ',&
        'UT08_ELGA       ', 'UT08_ELNO       ', 'UT08_ELEM       ', 'UT08_NOEU       ',&
        'UT09_ELGA       ', 'UT09_ELNO       ', 'UT09_ELEM       ', 'UT09_NOEU       ',&
        'UT10_ELGA       ', 'UT10_ELNO       ', 'UT10_ELEM       ', 'UT10_NOEU       '/)
!
! --------------------------------------------------------------------------------------------------
!
    resultName = resultNameZ
    resultType = resultTypeZ
    base       = baseZ
!
! - Create datastructure
!
    call jeexin(resultName//'.DESC', iret)
    ASSERT(iret .eq. 0)
    call jecreo(resultName//'.DESC', base//' N K16')
    call wkvect(resultName//'.ORDR', base//' V I', nbStore, jvDummy)
    call jeecra(resultName//'.ORDR', 'LONUTI', 0)
!
! - Create list of parameters
!
    call utpara(base, resultNameZ, resultTypeZ, nbStore)
!
! - Create list of fields
!
    if (resultType .eq. 'EVOL_ELAS') then
        nbField = nbFieldMeca + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='EVEL')
        do iField = 1, nbFieldMeca
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    else if (resultType .eq. 'MULT_ELAS') then
        nbField = nbFieldMeca + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='MUEL')
        do iField = 1, nbFieldMeca
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    else if (resultType .eq. 'FOURIER_ELAS') then
        nbField = nbFieldMeca + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='FOEL')
        do iField = 1, nbFieldMeca
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    else if (resultType .eq. 'FOURIER_THER') then
        nbField = nbFieldTher + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='FOTH')
        do iField = 1, nbFieldTher
            call jecroc(jexnom(resultName//'.DESC', fieldTher(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    else if (resultType .eq. 'EVOL_NOLI') then
        nbField = nbFieldMeca + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='EVNO')
        do iField = 1, nbFieldMeca
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    else if (resultType .eq. 'DYNA_TRANS') then
        nbField = nbFieldMeca + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='DYTR')
        do iField = 1, nbFieldMeca
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    else if (resultType .eq. 'DYNA_HARMO') then
        nbField = nbFieldMeca + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='DYHA')
        do iField = 1, nbFieldMeca
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    else if (resultType .eq. 'HARM_GENE') then
        nbField = nbFieldMeca + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='HAGE')
        do iField = 1, nbFieldMeca
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    else if (resultType .eq. 'ACOU_HARMO') then
        nbField = nbFieldAcou
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='ACHA')
        do iField = 1, nbField
            call jecroc(jexnom(resultName//'.DESC', fieldAcou(iField)))
        enddo
!
    else if (resultType .eq. 'EVOL_CHAR') then
        nbField = nbFieldChar
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='EVCH')
        do iField = 1, nbField
            call jecroc(jexnom(resultName//'.DESC', fieldChar(iField)))
        enddo
!
    else if (resultType .eq. 'EVOL_THER') then
        nbField = nbFieldTher + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='EVTH')
        do iField = 1, nbFieldTher
            call jecroc(jexnom(resultName//'.DESC', fieldTher(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    else if (resultType .eq. 'EVOL_VARC') then
        nbField = nbFieldVarc
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='EVVA')
        do iField = 1, nbField
            call jecroc(jexnom(resultName//'.DESC', fieldVarc(iField)))
        enddo
!
    elseif (resultType .eq. 'MODE_MECA') then
        nbField = nbFieldMeca
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='MOME')
        do iField = 1, nbField
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
!
    elseif (resultType .eq. 'MODE_MECA_C') then
        nbField = nbFieldMeca
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='MOME')
        do iField = 1, nbField
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
!
    elseif (resultType .eq. 'MODE_GENE') then
        nbField = nbFieldMeca
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='MOGE')
        do iField = 1, nbField
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
!
    else if (resultType.eq.'MODE_ACOU') then
        nbField = nbFieldMoac
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='MOAC')
        do iField = 1, nbField
            call jecroc(jexnom(resultName//'.DESC', fieldMoac(iField)))
        enddo
!
    else if (resultType .eq. 'MODE_FLAMB') then
        nbField = nbFieldMeca + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='MOFL')
        do iField = 1, nbFieldMeca
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    else if (resultType .eq. 'MODE_STAB') then
        nbField = nbFieldMeca + nbFieldUtil
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='MOSB')
        do iField = 1, nbFieldMeca
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
        do iField = 1, nbFieldUtil
            call jecroc(jexnom(resultName//'.DESC', fieldUtil(iField)))
        enddo
!
    elseif (resultType .eq. 'MODE_EMPI') then
        nbField = nbFieldRom
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='MOEM')
        do iField = 1, nbField
            call jecroc(jexnom(resultName//'.DESC', fieldRom(iField)))
        enddo
!
    else if (resultType .eq. 'COMB_FOURIER') then
        nbField = nbFieldMeca + nbFieldTher
        call jeecra(resultName//'.DESC', 'NOMMAX', nbField)
        call jeecra(resultName//'.DESC', 'DOCU', cval='COFO')
        do iField = 1, nbFieldMeca
            call jecroc(jexnom(resultName//'.DESC', fieldMeca(iField)))
        enddo
        do iField = 1, nbFieldTher
            call jecroc(jexnom(resultName//'.DESC', fieldTher(iField)))
        enddo
!
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Create TACH object
!
    call jecrec(resultName//'.TACH', base//' V K24', 'NU', 'CONTIG', 'CONSTANT', nbField)
    call jeecra(resultName//'.TACH', 'LONMAX', nbStore)
    do iField = 1, nbField
        call jecroc(jexnum(resultName//'.TACH', iField))
    end do
!
! - Create NOVA object (parameters)
!
    call jelira(resultName//'.NOVA', 'NOMMAX', nbNova)
    do iNova = 1, nbNova
        call jecroc(jexnum(resultName//'.TAVA', iNova))
    end do
!
end subroutine
