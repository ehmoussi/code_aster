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

subroutine op0128()
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 13/07/90
!-----------------------------------------------------------------------
!  BUT: ASSEMBLER UNE MATRICE ISSUE D'UN MODELE GENERALISE
!
!     CONCEPT CREE: MATR_ASSE_GENE
!
!-----------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/jexnum.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/asgeel.h"
#include "asterfort/assgcy.h"
#include "asterfort/assgen.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jeexin.h"
    integer :: iret,jdesc,n1,n2
    character(len=8) :: nomres, numeg
    character(len=9) :: method
    character(len=11) :: option
    character(len=14) :: nugene
    character(len=16) :: nomcon, nomope
    character(len=19) :: nomr19
!-----------------------------------------------------------------------
    integer :: ibid, iopt
!-----------------------------------------------------------------------
    call infmaj()
!
    call getres(nomres, nomcon, nomope)
!
!-------------------RECUPERATION CONCEPTS AMONT-------------------------
!
    call getvid(' ', 'NUME_DDL_GENE', scal=numeg, nbret=ibid)
    nugene=numeg
!
!-------------------------RECUPERATION DE L'OPTION----------------------
!
    call getvtx(' ', 'OPTION', scal=option, nbret=ibid)
!
!---------------------------------ASSEMBLAGE----------------------------
!
    call getvtx(' ', 'METHODE', scal=method, nbret=iopt)
!
!-- on teste si les objets pour l'elimination existent
    call jeexin(nugene//'.ELIM.BASE', iret)
!
    if (method .eq. 'CLASSIQUE') then
        if (iret .gt. 0) then
            call asgeel(nomres, option, nugene)
        else
            call assgen(nomres, option, nugene)
        endif
    else
        if (iret .gt. 0) then
            call asgeel(nomres, option, nugene)
        else
            call assgcy(nomres, nugene)
        endif
    endif


!   -- on corrige l'objet .DESC :
!   ------------------------------------------------------------------------------
    nomr19=nomres
    call jelira(nomr19//'.CONL','LONMAX',n1)
    call jelira(jexnum(nomr19//'.VALM',1),'LONMAX',n2)
    call jeveuo(nomr19//'.DESC','E',jdesc)
    zi(jdesc)=2
    zi(jdesc+1)=n1
    if (n2.eq.n1) then
        zi(jdesc+2)=1
    elseif (n2.eq.n1*(n1+1)/2) then
        zi(jdesc+2)=2
    else
        zi(jdesc+2)=3
    endif


end subroutine
