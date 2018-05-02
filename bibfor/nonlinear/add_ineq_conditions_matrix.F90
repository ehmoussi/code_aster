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

subroutine add_ineq_conditions_matrix(matass, matr, nume_ddl)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/infbav.h"
#include "asterfort/infdbg.h"
#include "asterfort/infmue.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mtcmbl.h"
#include "asterfort/sdmpic.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19) :: matass, matr
    character(len=14) :: nume_ddl
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - ALGORITHME)
!
! CREATION DE LA MATRICE DE CONTACT/FROTTEMENT
!
! ----------------------------------------------------------------------
!
! I/O MATASS  : IN  MATR_ASSE TANGENTE
!               OUT MATR_ASSE TANGENTE + MATRICE CONTACT/FROTTEMENT
!                  (EVENTUELLE)
!
! ----------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=24) :: limat(2)
    real(kind=8) :: coefmu(2)
    character(len=1) :: typcst(2)
    character(len=8) ::  kmpic1
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> AJOUT MATRICE CONTACT/FROTTEMENT'
    endif
!
    limat(1) = matass
    limat(2) = matr
    coefmu(1) = 1.d0
    coefmu(2) = 1.d0
    typcst(1) = 'R'
    typcst(2) = 'R'
!
    call detrsd('NUME_DDL', nume_ddl)
!
    call infmue()
    call dismoi('MPI_COMPLET', matass, 'MATR_ASSE', repk=kmpic1)
    if (kmpic1 .eq. 'NON') then 
        call sdmpic('MATR_ASSE', matass)
    endif
    
    call dismoi('MPI_COMPLET', matr, 'MATR_ASSE', repk=kmpic1)
    if (kmpic1 .eq. 'NON') then 
        call sdmpic('MATR_ASSE', matr)
    endif
    
    call mtcmbl(2, typcst, coefmu, limat, matass,&
                ' ', nume_ddl, 'ELIM1')
    call infbav()
    call dismoi('NOM_NUME_DDL', matr, 'MATR_ASSE', repk=nume_ddl)
    call detrsd('MATR_ASSE', matr)
    call detrsd('NUME_DDL', nume_ddl)
!
    call jedema()
!
end subroutine
