! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine apbloc(kptsc)
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
!
! person_in_charge: natacha.bereux at edf.fr
!
use aster_petsc_module
use petsc_data_module
!
    implicit none
    integer :: kptsc
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/wkvect.h"
#include "asterfort/jexnum.h"
#include "asterfort/jedetr.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!----------------------------------------------------------------
!
!  * Determination du nombre de ddls par noeud (le "blocksize" de PETSc)
!----------------------------------------------------------------
!
#ifdef _HAVE_PETSC
!
!----------------------------------------------------------------
!   -- variables locales :
    character(len=19) :: nomat, solveu
    character(len=14) :: nonu
    character(len=8) :: nomgd,noma,exilag
    integer :: tbloc, tbloc2
    character(len=24) :: precon
    aster_logical :: leliml, ndiff
    character(len=24), pointer :: slvk(:) => null()
    character(len=24), pointer :: refa(:) => null()

    integer:: k,ilig,neq,kec,nbec,nbnoma,nbddl
    integer:: jprno,n1,ino,ino_model,ecmax(10),ec1,ec2,nnz
    integer:: kbloc,i,ilig1,ilig2,k2,pos1_0,ieq,ieq1,ieq2
    integer:: jnueq,kcmp,neq2,nbnomo,nbddlt,ico,vali(4)
    aster_logical :: dbg=.false.
!
!----------------------------------------------------------------
    call jemarq()
    tbloc=1
    nomat = nomat_courant
    nonu = nonu_courant
    if (dbg) write(6,*) 'apbloc nomat=',nomat
    solveu = nosols(kptsc)


!   -- Quel preconditionneur ?
!      tbloc > 1 n'est utile que pour les precondionneurs  BOOMER, ML et GAMG
!   ---------------------------------------------------------------------------
    call jeveuo(solveu//'.SLVK', 'L', vk24=slvk)
    precon = slvk(2)
    if (dbg) write(6,*) 'apbloc precon=',precon
    if ((precon.ne.'ML') .and. (precon.ne.'BOOMER') .and. (precon.ne.'GAMG')) then
        if (dbg) write(6,*) "apbloc tbloc impose a 1 car PRE_COND ne l'utilise pas."
        tbloc = 1
        goto 999
    endif


!   -- La matrice/solveur est-elle ELIM_LAGR='OUI' ?  A-t-elle des ddls de Lagrange ?
!   -----------------------------------------------------------------------------------
    leliml = slvk(13)(1:3).eq.'OUI'
    call dismoi('EXIS_LAGR', nomat, 'MATR_ASSE', repk=exilag)


!   --  Si ELIM_LAGR='OUI', la matrice ne sera pas utilisee telle quelle pour la resolution Petsc.
!       On va d'abord la reduire.
!       => tbloc > 1 n'a pas d'interet.
!   ----------------------------------------------------------------------------------------------
    if (leliml) then
        if (dbg) write(6,*) 'apbloc tbloc impose a 1 car ELIM_LAGR=OUI'
        tbloc = 1
        goto 999
    endif

!   -- S'il y a des ddls de Lagrange, c'est cuit !
!   -------------------------------------------------------------------------------
    if (exilag.eq.'OUI')  call utmess('F', 'PETSC_18')
!
!   --  Si ELIM_LAGR='NON', on regarde si la matrice n'est pas la matrice reduite
!       associee a une matrice qui a utilise ELIM_LAGR='OUI'
!       Si oui, on fixe tbloc = 1
!   ----------------------------------------------------------------------------------------------
    if (.not.leliml) then
        call jeveuo(nomat//'.REFA', 'L', vk24=refa)
        if (refa(20).ne.' ') then
            tbloc = 1
            if (dbg) write(6,*) 'apbloc tbloc impose a 1 car refa(20)=',refa(20)
            goto 999
        endif
    endif
!
!   -- 1. On ne peut utiliser tbloc > 1 que si TOUS les noeuds du maillage portent les memes ddls
!         (memes entiers codes)
!         On va calculer :
!           * tbloc (si possible, sinon : erreur <F>)
!           * fictif=0/1
!              0 : Tous les noeuds ont exactement le meme nombre de ddls (tbloc)
!                  (sans ajouter de ddls fictifs)
!              1 : Tous les noeuds auront le meme nombre de ddls si on ajoute des ddls fictifs
!   -------------------------------------------------------------------------------------------
    call dismoi('NOM_MAILLA', nomat, 'MATR_ASSE', repk=noma)
    call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nbnoma)
    call dismoi('NOM_GD', nonu, 'NUME_DDL', repk=nomgd)
    call dismoi('NB_EC', nomgd, 'GRANDEUR', repi=nbec)
    ASSERT(nbec.le.10)
    call jeveuo(jexnum(nonu//'.NUME.PRNO', 1), 'L', jprno)
    call jelira(jexnum(nonu//'.NUME.PRNO', 1), 'LONMAX', n1)
    ASSERT(n1.eq.nbnoma*(nbec+2))
    if (dbg) write(6,*) 'apbloc nbec,nbnoma=',nbec,nbnoma

!   -- on interdit le cas NUEQ(ieq) /= ieq :
    call jeveuo(nonu//'.NUME.NUEQ','L', jnueq)
    call jelira(nonu//'.NUME.NUEQ', 'LONMAX', neq)
    do ieq=1,neq
        ASSERT(zi(jnueq-1+ieq).eq.ieq)
    enddo

!   -- calcul de fictif :
!   ---------------------
    ecmax(1:nbec)=0
    do ino=1,nbnoma
       nbddl=zi(jprno-1+(nbec+2)*(ino-1)+2)
       if (nbddl.eq.0) cycle
       do kec=1,nbec
           ec1=zi(jprno-1+(nbec+2)*(ino-1)+2+kec)
           ecmax(kec)=ior(ecmax(kec),ec1)
       enddo
    enddo
    if (dbg) write(6,*) 'apbloc ecmax=',ecmax(1:nbec)

!   -- calcul de tbloc :
!   --------------------
    tbloc=0
    do kec=1,nbec
        do kcmp=1,30
            if (iand(ecmax(kec),2**kcmp).eq.2**kcmp) tbloc=tbloc+1
        enddo
    enddo
    if (dbg) write(6,*) 'apbloc tbloc =',tbloc


!   -- les entiers codes sont-ils les memes sur TOUS les noeuds ?
!   -------------------------------------------------------------
    ino_model=0
    nbnomo=0
    nbddlt=0
    ndiff=.false.
    tbloc2=0
    do ino=1,nbnoma
       nbddl=zi(jprno-1+(nbec+2)*(ino-1)+2)
       if (nbddl.eq.0) cycle
       nbnomo=nbnomo+1
       nbddlt=nbddlt+nbddl
       if (ino_model.eq.0) then
           ino_model=ino
           tbloc2=nbddl
           if (dbg) write(6,*) 'apbloc ino_model,tbloc=',ino_model,tbloc2
       endif
       if (.not.ndiff) then
           do kec=1,nbec
               ec1=zi(jprno-1+(nbec+2)*(ino-1)+2+kec)
               ec2=zi(jprno-1+(nbec+2)*(ino_model-1)+2+kec)
               if (ec1 .ne. ec2) ndiff=.true.
           enddo
       endif
    enddo
! Si les entiers codés ne sont pas les mêmes sur tous le noeuds, on garde tbloc = 1
    if ( ndiff ) then
       tbloc = 1
    endif

999 continue

!   -- sauvegarde des informations calculees dans le common :
!   ---------------------------------------------------------
    tblocs(kptsc)=tbloc
    call jedema()
    if (dbg) write(6,*) 'apbloc tbloc=',tbloc
#else
    integer :: idummy
    idummy = kptsc
#endif

end subroutine
