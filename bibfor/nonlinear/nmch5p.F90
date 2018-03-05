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
subroutine nmch5p(veasse)
!
implicit none
!
#include "asterfort/nmcha0.h"
!
character(len=19) :: veasse(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (INITIALISATION)
!
! CREATION DES VARIABLES CHAPEAUX - VEASSE
!
! ----------------------------------------------------------------------
!
!
! OUT VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
!
! ----------------------------------------------------------------------
!
    character(len=19) :: cnfedo, cnfepi, cnfsdo, cndidi, cnfint
    character(len=19) :: cndido, cndipi, cncine, cndiri, cnfnod
    character(len=19) :: cnbudi, cnlapl, cnsstr, cnondp
    character(len=19) :: cneltc, cneltf
    character(len=19) :: cnsstf
    character(len=19) :: cnrefe
    character(len=19) :: cndyna, cnamod
    character(len=19) :: cnfext
    character(len=19) :: cnimpe, cnviss
!
    data cnfedo,cnfsdo    /'&&NMCH5P.CNFEDO','&&NMCH5P.CNFSDO'/
    data cndido,cnfepi    /'&&NMCH5P.CNDIDO','&&NMCH5P.CNFEPI'/
    data cndipi,cnfint    /'&&NMCH5P.CNDIPI','&&NMCH5P.CNFINT'/
    data cnbudi,cndidi    /'&&NMCH5P.CNBUDI','&&NMCH5P.CNDIDI'/
    data cnondp,cnlapl    /'&&NMCH5P.CNONDP','&&NMCH5P.CNLAPL'/
    data cndiri,cnfnod    /'&&NMCH5P.CNDIRI','&&NMCH5P.CNFNOD'/
    data cnsstf,cneltc    /'&&NMCH5P.CNSSTF','&&NMCH5P.CNELTC'/
    data cneltf           /'&&NMCH5P.CNELTF'/
    data cnrefe           /'&&NMCH5P.CNREFE'/
    data cncine,cnsstr    /'&&NMCH5P.CNCINE','&&NMCH5P.CNSSTR'/
    data cnamod           /'&&NMCH5P.CNAMOD'/
    data cndyna           /'&&NMCH5P.CNDYNA'/
    data cnfext           /'&&NMCH5P.CNFEXT'/
    data cnimpe           /'&&NMCH5P.CNIMPE'/
    data cnviss           /'&&NMCH5P.CNVISS'/
!
! ----------------------------------------------------------------------
!
    call nmcha0('VEASSE', 'ALLINI', ' ', veasse)
    call nmcha0('VEASSE', 'CNFINT', cnfint, veasse)
    call nmcha0('VEASSE', 'CNDIRI', cndiri, veasse)
    call nmcha0('VEASSE', 'CNBUDI', cnbudi, veasse)
    call nmcha0('VEASSE', 'CNFNOD', cnfnod, veasse)
    call nmcha0('VEASSE', 'CNDIDO', cndido, veasse)
    call nmcha0('VEASSE', 'CNDIPI', cndipi, veasse)
    call nmcha0('VEASSE', 'CNFEDO', cnfedo, veasse)
    call nmcha0('VEASSE', 'CNFEPI', cnfepi, veasse)
    call nmcha0('VEASSE', 'CNLAPL', cnlapl, veasse)
    call nmcha0('VEASSE', 'CNONDP', cnondp, veasse)
    call nmcha0('VEASSE', 'CNFSDO', cnfsdo, veasse)
    call nmcha0('VEASSE', 'CNIMPE', cnimpe, veasse)
    call nmcha0('VEASSE', 'CNDIDI', cndidi, veasse)
    call nmcha0('VEASSE', 'CNSSTF', cnsstf, veasse)
    call nmcha0('VEASSE', 'CNELTC', cneltc, veasse)
    call nmcha0('VEASSE', 'CNELTF', cneltf, veasse)
    call nmcha0('VEASSE', 'CNREFE', cnrefe, veasse)
!
! --- SANS VECT_ELEM POUR CONSTRUIRE
!
    call nmcha0('VEASSE', 'CNCINE', cncine, veasse)
    call nmcha0('VEASSE', 'CNSSTR', cnsstr, veasse)
    call nmcha0('VEASSE', 'CNDYNA', cndyna, veasse)
    call nmcha0('VEASSE', 'CNAMOD', cnamod, veasse)
    call nmcha0('VEASSE', 'CNFEXT', cnfext, veasse)
    call nmcha0('VEASSE', 'CNVISS', cnviss, veasse)
!
end subroutine
