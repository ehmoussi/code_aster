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
subroutine nmdebg(typobz, nomobz, ifm)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/tstobj.h"
#include "asterfort/utimsd.h"
!
character(len=*) :: nomobz, typobz
integer :: ifm
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE)
!
! IMPRIME LE CONTENU D'UN OBJET POUR DEBUG
!
! --------------------------------------------------------------------------------------------------
!
! IN  TYPOBJ : TYPE DE L'OBJET (VECT/MATR)
! IN  NOMOBJ : NOM DE L'OBJET
! IN  IFM    : UNITE D'IMPRESSION
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: nomobj
    character(len=4) :: typobj
    character(len=3) :: type
    real(kind=8) :: sommr
    integer :: resume, sommi, lonmax
    integer :: iret, ibid
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    nomobj = nomobz
    typobj = typobz
!
! --- IMPRESSION
!
    if (typobj .eq. 'VECT') then
        call tstobj(nomobj(1:19)//'.VALE', 'OUI', resume, sommi, sommr,&
                    ibid, lonmax, type, iret, ibid)
        if ((type.eq.'R') .and. (iret.eq.0)) then
            write (ifm,100) nomobj(1:19),lonmax,sommr
        endif
    else if (typobj.eq.'CHEL') then
        call tstobj(nomobj(1:19)//'.CELV', 'OUI', resume, sommi, sommr,&
                    ibid, lonmax, type, iret, ibid)
        if ((type.eq.'R') .and. (iret.eq.0)) then
            write (ifm,100) nomobj(1:19),lonmax,sommr
        endif
    else if (typobj.eq.'MATA') then
        call tstobj(nomobj(1:19)//'.VALM', 'OUI', resume, sommi, sommr,&
                    ibid, lonmax, type, iret, ibid)
        if ((type.eq.'R') .and. (iret.eq.0)) then
            write (ifm,100) nomobj(1:19),lonmax,sommr
        endif
    else
        call utimsd(ifm, -1, .true._1, .true._1, nomobj(1:24), 1, ' ', perm='OUI')
    endif
!
100 format (' <MECANONLINE>        ',a19,' | LONMAX=',i12, ' | SOMMR=',e30.21)
!
    call jedema()
!
end subroutine
