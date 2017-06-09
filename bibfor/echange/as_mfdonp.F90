! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine as_mfdonp(fid, cha, numdt, numo, typent,&
                     typgeo, iterma, noma, nompro, nomloc,&
                     n, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "asterfort/codent.h"
#include "asterfort/assert.h"
#include "asterfort/as_mfinvr.h"
#include "med/mfioex.h"
#include "med/mfdonp.h"
    aster_int :: fid, typent, typgeo, n, cret, numdt, numo, iterma
    aster_int :: maj, mini, rel
    character(len=*) :: nompro, nomloc, cha, noma
    character(len=20) :: numdtchar, numochar
    character(len=73) :: oname
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, typen4, typge4, n4, cret4, numdt4, numo4, iterm4
    med_int :: oexist4, class4
#else
    aster_int :: oexist, class
#endif
    call as_mfinvr(fid, maj, mini, rel, cret)
    if (maj.eq.3.and.mini.ge.2) then
        ! On reconstruit le nom oname du champ MED en fonction du
        ! champ et des numeros d'instant et d'ordre.
        ! On verifie ensuite que oname existe bien avant l'appel a mfdonp
        ! pour eviter les "Erreur à l'ouverture du groupe" dans Med
        call codent(numdt, 'D0', numdtchar)
        call codent(numo, 'D0', numochar)
        ASSERT(len(trim(cha)).le.32)
        oname = trim(cha)//'/'//numdtchar//numochar
    else
        ! On verifie uniquement le nom du champ si la version < 3.2
        oname = trim(cha)
    endif
#if med_int_kind != aster_int_kind
    fid4 = fid
    numdt4 = numdt
    numo4 = numo
    typen4 = typent
    typge4 = typgeo
    iterm4 = iterma
    ! class4 = 1 <=> field type
    class4 = 1_4
    call mfioex(fid4, class4, oname, oexist4, cret4)
    if (oexist4.eq.1) then
        call mfdonp(fid4, cha, numdt4, numo4, typen4,&
                    typge4, iterm4, noma, nompro, nomloc,&
                    n4, cret4)
        n = n4
        cret = cret4
    else
        n = 0
        cret = -1
    endif
#else
    ! class = 1 <=> field type
    class = 1
    call mfioex(fid, class, oname, oexist, cret)
    if (oexist.eq.1) then
        call mfdonp(fid, cha, numdt, numo, typent,&
                    typgeo, iterma, noma, nompro, nomloc,&
                    n, cret)
    else
        n = 0
        cret = -1
    endif
#endif
!
#endif
end subroutine
