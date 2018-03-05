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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmch4p(veelem)
!
implicit none
!
#include "asterfort/nmcha0.h"
!
character(len=19) :: veelem(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (INITIALISATION)
!
! CREATION DES VARIABLES CHAPEAUX - VEELEM
!
! ----------------------------------------------------------------------
!
! OUT VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
!
! ----------------------------------------------------------------------
!
    character(len=19) :: vefsdo, vefint, vebudi, vedido, vesstf
    character(len=19) :: vedipi, vefedo, vefepi, veondp
    character(len=19) :: vedidi, vediri, vefnod, velapl
    character(len=19) :: veeltc, veeltf
    character(len=19) :: verefe
    character(len=19) :: veimpp, veimpc
!
    data vefedo,vefsdo    /'&&NMCH4P.VEFEDO','&&NMCH4P.VEFSDO'/
    data vedido,vefepi    /'&&NMCH4P.VEDIDO','&&NMCH4P.VEFEPI'/
    data vedipi,vefint    /'&&NMCH4P.VEDIPI','&&NMCH4P.VEFINT'/
    data vebudi,vedidi    /'&&NMCH4P.VEBUDI','&&NMCH4P.VEDIDI'/
    data veondp,velapl    /'&&NMCH4P.VEONDP','&&NMCH4P.VELAPL'/
    data vediri,vefnod    /'&&NMCH4P.VEDIRI','&&NMCH4P.VEFNOD'/
    data vesstf,veeltc    /'&&NMCH4P.VESSTF','&&NMCH4P.VEELTC'/
    data veeltf           /'&&NMCH4P.VEELTF'/
    data verefe           /'&&NMCH4P.VEREFE'/
    data veimpp,veimpc    /'&&NMCH4P.VEIMPP','&&NMCH4P.VEIMPC'/
!
! ----------------------------------------------------------------------
!
    call nmcha0('VEELEM', 'ALLINI', ' ', veelem)
    call nmcha0('VEELEM', 'CNFINT', vefint, veelem)
    call nmcha0('VEELEM', 'CNDIRI', vediri, veelem)
    call nmcha0('VEELEM', 'CNBUDI', vebudi, veelem)
    call nmcha0('VEELEM', 'CNFNOD', vefnod, veelem)
    call nmcha0('VEELEM', 'CNDIDO', vedido, veelem)
    call nmcha0('VEELEM', 'CNDIPI', vedipi, veelem)
    call nmcha0('VEELEM', 'CNFEDO', vefedo, veelem)
    call nmcha0('VEELEM', 'CNFEPI', vefepi, veelem)
    call nmcha0('VEELEM', 'CNLAPL', velapl, veelem)
    call nmcha0('VEELEM', 'CNONDP', veondp, veelem)
    call nmcha0('VEELEM', 'CNFSDO', vefsdo, veelem)
    call nmcha0('VEELEM', 'CNIMPP', veimpp, veelem)
    call nmcha0('VEELEM', 'CNIMPC', veimpc, veelem)
    call nmcha0('VEELEM', 'CNDIDI', vedidi, veelem)
    call nmcha0('VEELEM', 'CNSSTF', vesstf, veelem)
    call nmcha0('VEELEM', 'CNELTC', veeltc, veelem)
    call nmcha0('VEELEM', 'CNELTF', veeltf, veelem)
    call nmcha0('VEELEM', 'CNREFE', verefe, veelem)
!
end subroutine
