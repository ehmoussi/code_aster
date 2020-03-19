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

subroutine cachvc(modelz, matez, matecoz, carelz, numedz, compoz,&
                  comz, chthz, ihydr, isech, itemp,&
                  iptot)
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/asasve.h"
#include "asterfort/nmvcd2.h"
#include "asterfort/vectme.h"
#include "asterfort/vecvme.h"
    character(len=*) :: modelz, carelz, matez, matecoz
    character(len=*) :: numedz, compoz, chthz
    character(len=*) :: comz
    integer          :: ihydr, isech, itemp, iptot
!
    character(len=1) :: typres
    character(len=16) :: option
    character(len=24) :: blan24, vecths
!
    character(len=24) :: modele, carele, mate, mateco
    character(len=24) :: numedd, compor, chths
    character(len=14) :: com
!
    modele = modelz
    carele = carelz
    numedd = numedz
    compor = compoz
    com = comz
    mate = matez
    mateco = matecoz
!
    typres = 'R'
    blan24 = ' '
!
!      ==> CAS DU CHARGEMENT TEMPERATURE, HYDRATATION, SECHAGE,
!          PRESSION TOTALE (CHAINAGE HM)
!
    vecths = blan24
    if (itemp.eq.1) then
        call vectme(modele, carele, mate, mateco, compor, com,&
                    vecths)
        call asasve(vecths, numedd, typres, chths)
    endif
    if (ihydr.eq.1) then
        option = 'CHAR_MECA_HYDR_R'
        call vecvme(option, modele, carele, mate, mateco, compor,&
                    com, numedd, chths)
    endif
    if (iptot.eq.1) then
        option = 'CHAR_MECA_PTOT_R'
        call vecvme(option, modele, carele, mate, mateco, compor,&
                    com, numedd, chths)
    endif
    if (isech.eq.1) then
        option = 'CHAR_MECA_SECH_R'
        call vecvme(option, modele, carele, mate, mateco, compor,&
                    com, numedd, chths)
    endif
    chthz = chths
!
end subroutine
