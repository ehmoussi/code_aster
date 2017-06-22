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

subroutine op0127()
!    P. RICHARD     DATE 13/07/90
!-----------------------------------------------------------------------
!    BUT: CREER LA NUMEROTATION DES DEGRES DE LIBERTE GENERALISES
!    CONCEPT CREE: NUME_DDL_GENE
!-----------------------------------------------------------------------
!
    implicit none
!
!
!
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jevtbl.h"
#include "asterfort/nugeel.h"
#include "asterfort/numgcy.h"
#include "asterfort/numgen.h"
#include "asterfort/nummod.h"
#include "asterfort/smosli.h"
#include "asterfort/strmag.h"
    character(len=8) :: nomres, modgen, modmec, option
    character(len=16) :: nomcon, nomope
    character(len=14) :: nugene
    character(len=24) :: typrof
    integer :: ibid1, ibid2, iopt
!
!
!-----------------------------------------------------------------------
    call infmaj()
!
!-----RECUPERATION DU MODELE AMONT
!
    call getvid(' ', 'MODELE_GENE', scal=modgen, nbret=ibid1)
    call getvid(' ', 'BASE', scal=modmec, nbret=ibid2)
!
!
    call getvtx(' ', 'STOCKAGE', scal=typrof, nbret=ibid2)
!
    call getres(nomres, nomcon, nomope)
    nugene=nomres
!
!
!-----NUMEROTATION DES DEGRES DE LIBERTE
    if (ibid1 .ne. 0) then
        call getvtx(' ', 'METHODE', scal=option, nbret=iopt)
        if (option .eq. 'CLASSIQU') then
            call numgen(nugene, modgen)
            call strmag(nugene, typrof)
        else if (option(1:7).eq.'INITIAL') then
            call numgcy(nugene, modgen)
        else if (option(1:7).eq.'ELIMINE') then
            call nugeel(nugene, modgen)
!          WRITE(6,*)' '
!          WRITE(6,*)'*** ON FORCE LE STOCKAGE PLEIN ***'
!          WRITE(6,*)' '
            typrof='PLEIN'
            call strmag(nugene, typrof)
        endif
    else if (ibid2.ne.0) then
        call nummod(nugene, modmec)
    endif
!
end subroutine
