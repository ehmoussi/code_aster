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
subroutine compMecaChckStrain(iComp,&
                              model         , fullElemField   ,&
                              lAllCellAffe, cellAffe      , nbCellAffe   ,&
                              lMfront      , exteDefo   ,&
                              defoComp     , defoCompPY,&
                              relaComp     , relaCompPY)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/lctest.h"
#include "asterfort/assert.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/cesexi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/lteatt.h"
#include "asterfort/teattr.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: iComp
character(len=8), intent(in) :: model
character(len=19), intent(in) :: fullElemField
aster_logical, intent(in) :: lAllCellAffe
character(len=24), intent(in) :: cellAffe
integer, intent(in) :: nbCellAffe
aster_logical, intent(in) :: lMfront
integer, intent(in) :: exteDefo
character(len=16), intent(in) :: defoComp, defoCompPY
character(len=16), intent(in) :: relaComp, relaCompPY
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Checking the consistency of the strain model with the behaviour
!
! --------------------------------------------------------------------------------------------------
!
! In  iComp            : occurrence number
! In  model            : name of model
! In  fullElemField    : field for FULL_MECA option
! In  lAllCellAffe     : ASTER_TRUE if affect on all cells where behaviour is defined
! In  nbCellAffe       : number of cells where behaviour is defined
! In  cellAffe         : list of cells where behaviour is defined
! In  lMfront          : flag if MFront
! In  exteDefo         : strain model for external behaviour (MFront)
! In  defoComp         : comportement DEFORMATION
! In  defoCompPY       : comportement DEFORMATION - Python coding
! In  relaComp         : comportment RELATION
! In  relaCompPY       : comportement RELATION - Python coding
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: elemTypeName, modelType, modelType2
    integer :: elemTypeNume, cellNume
    character(len=8) :: grille
    integer :: jvCesd, jvCesl, jvCesv, jvVale
    integer :: modelTypeIret, lctestIret, iCell, modelTypeIret2
    integer :: nbCellMesh, nbCell
    integer, pointer :: cellAffectedByModel(:) => null()
    integer, pointer :: listCellAffe(:) => null()
    aster_logical :: l_coq3d, l_dkt, l_dktg, lShell, l_hho
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Access to model
!
    call jeveuo(model//'.MAILLE', 'L', vi = cellAffectedByModel)
!
! - Access to <CHELEM_S> of FULL_MECA option
!
    call jeveuo(fullElemField//'.CESD', 'L', jvCesd)
    call jeveuo(fullElemField//'.CESL', 'L', jvCesl)
    call jeveuo(fullElemField//'.CESV', 'L', jvCesv)
    nbCellMesh = zi(jvCesd-1+1)
!
! - Mesh affectation
!
    if (lAllCellAffe) then
        nbCell = nbCellMesh
    else
        call jeveuo(cellAffe, 'L', vi = listCellAffe)
        nbCell = nbCellAffe
    endif
!
! - Check consistency with catalog
!
    call lctest(relaCompPY, 'DEFORMATION', defoComp, lctestIret)
    if (lctestIret .eq. 0) then
        call utmess('F', 'COMPOR1_44', nk = 2, valk = [defoComp, relaComp])
    endif
!
! - Loop on elements
!
    do iCell = 1, nbCell
! ----- Current cell
        if (lAllCellAffe) then
            cellNume = iCell
        else
            cellNume = listCellAffe(iCell)
        endif

! ----- Get adress in field for FULL_MECA option
        call cesexi('C', jvCesd, jvCesl, cellNume, 1, 1, 1, jvVale)

        if (jvVale .gt. 0) then

! --------- Access to type of finite element
            elemTypeNume = cellAffectedByModel(cellNume)
            call jenuno(jexnum('&CATA.TE.NOMTE', elemTypeNume), elemTypeName)

! --------- Type of modelization
            call teattr('C', 'TYPMOD' , modelType , modelTypeIret, typel = elemTypeName)
            call teattr('C', 'TYPMOD2', modelType2, modelTypeIret2, typel = elemTypeName)
            l_hho   = modelType2(1:3) .eq. 'HHO'
            l_coq3d = lteatt('MODELI','CQ3', typel = elemTypeName)
            l_dkt   = lteatt('MODELI','DKT', typel = elemTypeName)
            l_dktg  = lteatt('MODELI','DTG', typel = elemTypeName)
            lShell  = lteatt('COQUE' ,'OUI', typel = elemTypeName)

! --------- Specific checks
            if (l_dkt .and. defoComp .eq. 'PETIT_REAC') then
                call utmess('A', 'COMPOR1_50')
            endif

            if (l_coq3d .and. (defoComp .eq. 'GROT_GDEP')) then
                call utmess('A', 'COMPOR1_47')
            endif

            if (l_hho .and.&
                (defoComp .eq. 'SIMO_MIEHE' .or. defoComp .eq. 'PETIT_REAC')) then
                call utmess('F', 'COMPOR1_49')
            endif

            if (l_dkt .and. .not. l_dktg ) then
                if ((defoComp .eq. 'GROT_GDEP') .and. (relaComp(1:4).ne.'ELAS')) then
                    call utmess('F', 'COMPOR1_48')
                endif
            endif

! --------- Check model of strains for Mfront
            if (lMfront) then
                if (exteDefo .eq. MFRONT_STRAIN_SMALL) then
                    if (defoComp .ne. 'PETIT' .and.&
                        defoComp .ne. 'PETIT_REAC' .and.&
                        defoComp .ne. 'GDEF_LOG' .and.&
                        defoComp .ne. 'GROT_GDEP' ) then
                        call utmess('F', 'COMPOR4_35', sk = defoComp)
                    endif
                endif
                if (exteDefo .eq. MFRONT_STRAIN_SIMOMIEHE) then
                    if (defoComp .ne. 'SIMO_MIEHE' ) then
                        call utmess('F', 'COMPOR4_35', sk = defoComp)
                    endif
                endif
                if (exteDefo .eq. MFRONT_STRAIN_GROTGDEP) then
                    if (defoComp .ne. 'GROT_GDEP' .and.&
                        defoComp .ne. 'PETIT' ) then
                        call utmess('F', 'COMPOR4_35', sk = defoComp)
                    endif
                endif
            endif

! --------- Generic checks
            if (modelTypeIret .eq. 0) then
                if (modelType .eq. 'C_PLAN') then
                    if (defoComp .eq. 'GROT_GDEP' .and. relaComp .eq. 'ELAS'&
                        .and. .not. lShell) then
                        call utmess('F', 'COMPOR1_15')
                    else
                        call lctest(defoCompPY, 'MODELISATION', 'C_PLAN', lctestIret)
                        if (lctestIret .eq. 0) then
                            call utmess('F', 'COMPOR5_23', si = iComp,&
                                                           nk=2, valk=[defoComp, elemTypeName])
                        endif
                    endif

                elseif (modelType .eq. '3D') then
                    call lctest(defoCompPY, 'MODELISATION', '3D', lctestIret)
                    if (lctestIret .eq. 0) then
                        call utmess('F', 'COMPOR5_23', si = iComp,&
                                                       nk=2, valk=[defoComp, elemTypeName])
                    endif

                else if (modelType .eq. '1D') then
                    if (modelType2 .eq. 'PMF') then
                        call lctest(defoCompPY, 'MODELISATION', 'PMF', lctestIret)
                        if (lctestIret .eq. 0) then
                            call utmess('F', 'COMPOR5_23', si = iComp,&
                                                           nk=2, valk=[defoComp, elemTypeName])
                        endif
                    else
                        call teattr('C', 'GRILLE', grille, modelTypeIret, typel=elemTypeName)
                        if (grille(1:3).eq.'OUI') then
                            call lctest(defoCompPY, 'MODELISATION', 'GRILLE', lctestIret)
                        else
                            call lctest(defoCompPY, 'MODELISATION', '1D', lctestIret)
                        endif
                        if (lctestIret .eq. 0) then
                            call utmess('F', 'COMPOR5_23', si = iComp,&
                                                           nk=2, valk=[defoComp, elemTypeName])
                        endif
                    endif

                else
                    call lctest(defoCompPY, 'MODELISATION', modelType, lctestIret)
                    if (modelType .ne. '0D') then
                        if (lctestIret .eq. 0) then
                            call utmess('F', 'COMPOR5_23', si = iComp,&
                                                           nk=2, valk=[defoComp, elemTypeName])
                        endif
                    endif

                endif
            endif
        endif
    end do
!
    call jedema()
!
end subroutine
