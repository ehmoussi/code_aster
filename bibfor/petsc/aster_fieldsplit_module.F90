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
!
!
! MultiPhysics problems involve several physical fields.
! Code_Aster uses a monolithic approach, to address
! strongly coupled problems.
! MFIELD preconditionner uses PETSc PCFIELDSPLIT framework to build a block
! preconditioner built on Schur complements methods and single-field
! preconditioning techniques.
! The target application is THM studies.
! This module provides tools to setup a MFIELD preconditionner.
!
module aster_fieldsplit_module
!
!
!
#include "asterf_types.h"
#include "asterf_petsc.h"
#ifdef _HAVE_PETSC
    use petscksp
    use petscpc
    use petsc_data_module
    use aster_petsc_module
!
    implicit none
    private
#include "jeveux.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvis.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
!
    public :: mfield_setup
!
contains
!
! Build a fieldsplit preconditioner
!
    subroutine mfield_setup(kptsc, nonu)
!
!
! Dummy arguments
!
        integer, intent(in) :: kptsc
        character(len=14), intent(in) :: nonu
!
!  Local variables
!
        mpi_int :: rang, nbproc, mpicomm
        integer :: jerr
        PetscErrorCode :: ierr
        PC, dimension(:), allocatable :: pc_list
        IS, dimension(:), allocatable :: is_list
        IS, dimension(:), allocatable :: subis_list
        IS :: current_is, is_with_bs_3
        PC :: pc
        PetscInt :: nu, mg, ng
        PetscInt :: bs, nsplit
        KSP, dimension(:), allocatable :: subksp
        Mat :: Mat_temp
        aster_logical :: debug
!========================
        integer, dimension(:), allocatable :: fields_size
        integer :: nb_cmp_global
        integer :: idx, nb_fields, start, end, ntot, i, length1, length2
        character(len=8), dimension(:), allocatable :: cmp_global
        character(len=256) :: field_name1, field_name2
        character(len=2500) :: myopt
        integer :: ifm, niv
!
!  Get debug level
!  ---------------------
        call infniv(ifm, niv)
        debug = .false.
        if (niv .ge. 2) debug=.true.
!
!  Get parallel context:
!  ---------------------
!  Rank, number of processes, communicator
        call asmpi_info(rank=rang, size=nbproc)
        call asmpi_comm('GET', mpicomm)
!  Give the main solver a name
        call PetscObjectSetName(kp(kptsc), 'Top level KSP', ierr)
        ASSERT(ierr == 0)
!  Get current preconditioner
        call KSPGetPC(kp(kptsc), pc, ierr)
        ASSERT(ierr == 0)
!
!  Build IndexSets
!  ---------------
!
! Read fieldsplit information
! list of cmp
        call getvtx('SOLVEUR', 'NOM_CMP', iocc=1, nbval=0, nbret=nb_cmp_global)
        nb_cmp_global=-nb_cmp_global
        allocate(cmp_global(nb_cmp_global), stat=ierr)
        call getvtx('SOLVEUR', 'NOM_CMP', iocc=1, nbval=nb_cmp_global, &
                     vect=cmp_global,nbret=jerr)
! number of cmp in each fieldsplit
        call getvis('SOLVEUR', 'PARTITION_CMP', iocc=1, nbval=0, nbret=nb_fields)
        nb_fields=-nb_fields
        allocate(fields_size(nb_fields), stat=ierr)
        call getvis('SOLVEUR', 'PARTITION_CMP', iocc=1, nbval=nb_fields, &
                    vect=fields_size, nbret=jerr)
! PETSc solver options
        call getvtx('SOLVEUR', 'OPTION_PETSC', iocc=1, nbval=1, scal=myopt,&
                    nbret=jerr)
!
!  an IS is built for each "physical field" ,
!  a "physical field" is defined by a group of components
!  Example for nb_fields=4 fields with fields_size=(3,1,1,1)
!    DX DY DZ | PRE1 | PRE2 | TEMP
!    <---------------------> <--->  is_list(1) is_list(2)       - level 1
!    <--------------> <--->         is_list(3) is_list(4)       - level 2
!    <-------> <--->                is_list(5) is_list(6)       - level 3
!    <~~~~~~~~~~~~~~> <~~~>         subis_list(1) subis_list(2)
!    <~~~~~~~> <~~~>                subis_list(3) subis_list(4)
!    subis are dedicated to described how some IS are embedded in another
!    For instance, subis_list(1) subis_list(2) are embedded in is_list(1)
!    and subis_list(3) subis_list(4) are embedded in is_list(3)
!
        allocate(is_list(2*(nb_fields-1)), stat=ierr)
! First, we build is_list, based on the user information
! We treat them by pair, one pair per level
        do idx = 1, nb_fields-1
! the block size of fields - if the fields are mixed, no bs possible
            bs=1
! exception for the last iteration wich concerns a single field where we need the real bs
! is_list(5) in the above example
            if (idx==nb_fields-1) bs=fields_size(nb_fields-idx)
            start=1
            end=sum(fields_size(1:nb_fields-idx))
            call get_is_of_field(is_list(2*idx-1), nonu, ap(kptsc), cmp_global(start:end), bs)
            if (debug) write(ifm, *) "Treating field nb ", 2*idx-1, ": ", cmp_global(start:end),&
                       " with bs=", bs
! the single block
            bs=fields_size(nb_fields-idx+1)
            start=sum(fields_size(1:nb_fields-idx))+1
            end=sum(fields_size(1:nb_fields-idx+1))
            call get_is_of_field(is_list(2*idx), nonu, ap(kptsc), cmp_global(start:end), bs)
            if (debug) write(ifm, *) "Treating field nb ", 2*idx, ": ", cmp_global(start:end),&
                       " with bs=", bs
        enddo
!
!  Check IS dimensions
        ntot=0
        do idx = 2, size(is_list), 2
            call ISGetSize(is_list(idx), nu, ierr)
            ASSERT(ierr == 0)
            ntot=ntot+nu
        enddo
        call ISGetSize(is_list(size(is_list)-1), nu, ierr)
        ASSERT(ierr == 0)
        ntot=ntot+nu
!
        call MatGetSize(ap(kptsc), mg, ng, ierr)
        ASSERT(ierr == 0)
        ASSERT( mg == ng )
        ASSERT( ng == ntot )
!
!  Build PC and KSP
!  ----------------
!
! We clear the options database and only maitain the options from the command file
        call PetscOptionsClear(PETSC_NULL_OPTIONS, ierr)
        ASSERT(ierr == 0)
        call PetscLogDefaultBegin(ierr)
        ASSERT(ierr.eq.0)
        call PetscOptionsInsertString(PETSC_NULL_OPTIONS, myopt, ierr)
        ASSERT(ierr == 0)
!
! Allocation of the PC, KSP and sub-IS, which define how fields are embeded in each other
        allocate(pc_list(nb_fields-1), stat=ierr)
        ASSERT(ierr == 0)
        allocate(subksp(2*(nb_fields-1)), stat=ierr)
        ASSERT(ierr == 0)
        allocate(subis_list(nb_fields), stat=ierr)
        ASSERT(ierr == 0)
! loop over the different levels to assign them PC and KSP.
! for each level we define 1 PC, specify the 2 IS of components that it deals with
! and we define the 2 sub-KSP to treat the 2 IS
        do idx = 1, nb_fields-1
            ! build the name of the field1 of the current level
            start=1
            end=sum(fields_size(1:nb_fields-idx))
            field_name1=''
            length1=len_trim(field_name1)
            do i = start, end
                field_name1=field_name1(1:length1)//cmp_global(i)
                length1=length1+len_trim(cmp_global(i))
            enddo
            ! Get the current PC
            if (idx==1) then
                call KSPGetPC(kp(kptsc), pc_list(idx), ierr)
            else
                call KSPGetPC(subksp(2*(idx-1)-1), pc_list(idx), ierr)
            endif
            ASSERT( ierr == 0 )
            ! Set the PC as a fieldsplit PC
            call PCSetType(pc_list(idx), PCFIELDSPLIT, ierr)
            ASSERT(ierr == 0)
            ! Define how the first field is preconditioned
            if (idx==1) then
                current_is = is_list(2*idx-1)
            else
                call is_embed_global(is_list(2*idx-1), is_list(2*idx-3), subis_list(idx-1),&
                                     subis_list(idx))
                current_is = subis_list(idx-1)
            endif
            call PCFieldSplitSetIS(pc_list(idx), field_name1(1:length1), current_is, ierr)
            if (field_name1(1:length1)=='DXDYDZ') then
                call ISSetBlockSize(current_is, to_petsc_int(3), ierr)
                is_with_bs_3=current_is
            endif
            ASSERT(ierr == 0)
!
            ! build the name of the field1 of the current level
            start=sum(fields_size(1:nb_fields-idx))+1
            end=sum(fields_size(1:nb_fields-idx+1))
            field_name2=''
            length2=len_trim(field_name2)
            do i = start, end
                field_name2=field_name2(1:length2)//cmp_global(i)
                length2=length2+len_trim(cmp_global(i))
            enddo
            ! Define how the second field is preconditioned
            if (idx==1) then
                current_is = is_list(2*idx)
            else
                current_is = subis_list(idx)
            endif
            call PCFieldSplitSetIS(pc_list(idx), field_name2(1:length2), current_is, ierr)
            if (field_name2(1:length2)=='DXDYDZ') then
                call ISSetBlockSize(current_is, to_petsc_int(3), ierr)
                is_with_bs_3=current_is
            endif
            ASSERT(ierr == 0)
!
!  Use runtime configuration
            call PCSetFromOptions(pc_list(idx), ierr)
            ASSERT( ierr == 0 )
!  Need to call PCSetUp before configuring the second level
            call PCSetup(pc_list(idx), ierr)
            ASSERT( ierr == 0 )
            nsplit=2
            call PCFieldSplitGetSubKSP(pc_list(idx), nsplit, subksp(2*idx-1:2*idx), ierr)
            ASSERT( ierr == 0 )
            call PetscObjectSetName(subksp(2*idx-1), ' KSP  '//field_name1(1:length1), ierr)
            ASSERT(ierr == 0)
            call PetscObjectSetName(subksp(2*idx), ' KSP  '//field_name2(1:length2), ierr)
            ASSERT(ierr == 0)
!
!  Configure the subksp, compute and join the near null space to the submatrix
!
            call KSPSetFromOptions(subksp(2*idx-1), ierr)
            ASSERT( ierr == 0 )
            call KSPGetOperators(subksp(2*idx-1), PETSC_NULL_MAT, Mat_temp, ierr)
            ASSERT( ierr == 0 )
            call MatGetBlockSize(Mat_temp, bs, ierr)
            ASSERT( ierr == 0 )
            if (bs==3) then
                call setNearNullSpace(Mat_temp, is_with_bs_3, nonu)
                if (debug) write(ifm, *)&
                           "Attaching a Null Space to the submatrix related to field ",&
                           field_name1(1:length1)
            endif
            call KSPSetFromOptions(subksp(2*idx), ierr)
            ASSERT( ierr == 0 )
            call KSPGetOperators(subksp(2*idx), PETSC_NULL_MAT, Mat_temp, ierr)
            ASSERT( ierr == 0 )
            call MatGetBlockSize(Mat_temp, bs, ierr)
            ASSERT( ierr == 0 )
            if (bs==3) then
                call setNearNullSpace(Mat_temp, is_with_bs_3, nonu)
                if (debug) write(ifm, *)&
                           "Attaching a Null Space to the submatrix related to field ",&
                           field_name2(1:length2)
            endif
            !
!
        enddo
!
! Free the local objects
        deallocate(cmp_global)
        deallocate(fields_size)
        deallocate(is_list)
        deallocate(pc_list)
        deallocate(subksp)
        deallocate(subis_list)
        call ISDestroy(current_is, ierr)
        ASSERT( ierr == 0 )
        call ISDestroy(is_with_bs_3, ierr)
        ASSERT( ierr == 0 )
!
    end subroutine mfield_setup
!
    subroutine setNearNullSpace(myMat, is_with_bs_3, nonu)
!
! Dummy arguments
!
        Mat, intent(in) :: myMat
        IS, intent(in) :: is_with_bs_3
        character(len=14), intent(in) :: nonu
!
!  Local variables
!
        mpi_int :: rang, nbproc, mpicomm
        PetscErrorCode :: ierr
        MatNullSpace :: sp
        PetscScalar :: xx_v(1)
        PetscOffset :: xx_i
        Vec :: coords, displ_coords
        PetscInt :: low, high, bs
        character(len=19) :: nomat
        character(len=8) :: nomail
        character(len=3) :: matd
        integer :: dimgeo, dimgeo_b, jnequ, neqg, jnequl, nterm
        real(kind=8), dimension(:), pointer :: coordo => null()
        integer, dimension(:), pointer :: prddl => null()
        integer, dimension(:), pointer :: deeq => null()
        integer, dimension(:), pointer :: nulg => null()
        integer, dimension(:), pointer :: nlgp => null()
        integer :: numno, icmp, ieq, ix
        integer :: nloc, ndprop, neqg_mail
        integer :: il, iga_f, igp_f
        real(kind=8) :: val
        aster_logical :: lmd, lmhpc
!
!  Determine the rigid body modes
        call asmpi_info(rank=rang, size=nbproc)
        call asmpi_comm('GET', mpicomm)
!
        call dismoi('NOM_MAILLA', nonu, 'NUME_DDL', repk=nomail)
        call dismoi('DIM_GEOM_B', nomail, 'MAILLAGE', repi=dimgeo_b)
        call dismoi('DIM_GEOM', nomail, 'MAILLAGE', repi=dimgeo)
        call dismoi('NB_NO_MAILLA', nomail, 'MAILLAGE', repi=neqg_mail)
        neqg_mail=neqg_mail*3
!
!   Distribution style
        nomat = nomat_courant
        call dismoi('MATR_DISTRIBUEE', nomat, 'MATR_ASSE', repk=matd)
        lmd = ( matd == 'OUI' )
        call dismoi('MATR_HPC', nomat, 'MATR_ASSE', repk=matd)
        lmhpc = (matd == 'OUI')
        ASSERT(.not.(lmd .and. lmhpc))
!
!
        call jeveuo(nonu//'.NUME.NEQU', 'L', jnequ)
        neqg=zi(jnequ)
        call jeveuo(nonu//'.NUME.DEEQ', 'L', vi=deeq)
        call jeveuo(nomail//'.COORDO    .VALE', 'L', vr=coordo)
!
        bs=3
!
        call VecCreate(mpicomm, coords, ierr)
        ASSERT(ierr == 0)
        call VecSetBlockSize(coords, bs, ierr)
        ASSERT(ierr == 0)
        if (lmd .or. lmhpc) then
            if (lmd) then
                call jeveuo(nonu//'.NUML.NEQU', 'L', jnequl)
                call jeveuo(nonu//'.NUML.PDDL', 'L', vi=prddl)
                nloc=zi(jnequl)
            else
                call jeveuo(nonu//'.NUME.NEQU', 'L', jnequ)
                call jeveuo(nonu//'.NUME.PDDL', 'L', vi=prddl)
                nloc = zi(jnequ)
                neqg = zi(jnequ+1)
            endif
! Nb de ddls dont le proc courant est propriétaire (pour PETSc)
            ndprop = 0
            do il = 1, nloc
                if (prddl(il) == rang) then
                    ndprop = ndprop + 1
                endif
            end do
            call VecSetSizes(coords, to_petsc_int(ndprop), to_petsc_int(neqg), ierr)
        else
            call VecSetSizes(coords, PETSC_DECIDE, to_petsc_int(neqg), ierr)
        endif
        call VecSetType(coords, VECMPI, ierr)
!           * REMPLISSAGE DU VECTEUR
!             coords: vecteur PETSc des coordonnées des noeuds du maillage,
!             dans l'ordre de la numérotation PETSc des équations
        if (lmd .or. lmhpc) then
            if (lmd) then
                call jeveuo(nonu//'.NUML.NULG', 'L', vi=nulg)
                call jeveuo(nonu//'.NUML.NLGP', 'L', vi=nlgp)
                do il = 1, nloc
! Indice global PETSc (F) correspondant à l'indice local il
                    igp_f = nlgp( il )
! Indice global Aster (F) correspondant à l'indice local il
                    iga_f = nulg( il )
! Noeud auquel est associé le ddl global Aster iga_f
                    numno = deeq( (iga_f -1)* 2 +1 )
! Composante (X, Y ou Z) à laquelle est associé
! le ddl global Aster iga_f
                    icmp = deeq( (iga_f -1)* 2 +2 )
                    ASSERT((numno .gt. 0) .and. (icmp .gt. 0))
! Valeur de la coordonnée (X,Y ou Z) icmp du noeud numno
                    val = coordo( dimgeo_b*(numno-1)+icmp )
! On met à jour le vecteur PETSc des coordonnées
                    nterm=1
                    call VecSetValues(coords, to_petsc_int(nterm), [to_petsc_int(igp_f - 1)],&
                                      [val], INSERT_VALUES, ierr)
                    ASSERT( ierr == 0 )
                enddo
            else
                call jeveuo(nonu//'.NUME.NULG', 'L', vi=nulg)
                do il = 1, nloc
! Indice global PETSc (F) correspondant à l'indice local il
                    igp_f = nulg ( il ) + 1
! Indice global Aster (F) correspondant à l'indice local il
                    iga_f = il
! Noeud auquel est associé le ddl global Aster iga_f
                    numno = deeq( (iga_f -1)* 2 +1 )
! Composante (X, Y ou Z) à laquelle est associé
! le ddl global Aster iga_f
                    icmp = deeq( (iga_f -1)* 2 +2 )
                    ASSERT((numno .gt. 0) .and. (icmp .gt. 0))
! Valeur de la coordonnée (X,Y ou Z) icmp du noeud numno
                    val = coordo( dimgeo_b*(numno-1)+icmp )
! On met à jour le vecteur PETSc des coordonnées
                    nterm=1
                    call VecSetValues(coords, to_petsc_int(nterm), [to_petsc_int(igp_f - 1)],&
                                      [val], INSERT_VALUES, ierr)
                    ASSERT( ierr == 0 )
                enddo
            endif
            call VecAssemblyBegin(coords, ierr)
            call VecAssemblyEnd(coords, ierr)
            ASSERT( ierr == 0 )
! la matrice est centralisée
        else
            call VecGetOwnershipRange(coords, low, high, ierr)
            call VecGetArray(coords, xx_v, xx_i, ierr)
            ix=0
            do ieq = low+1, high
! Noeud auquel est associé le ddl Aster ieq
                numno = deeq( (ieq -1)* 2 +1 )
! Composante (X, Y ou Z) à laquelle est associé
! le ddl Aster ieq
                icmp = deeq( (ieq -1)* 2 +2 )
                ASSERT((numno .gt. 0) .and. (icmp .gt. 0))
                ix=ix+1
                xx_v(xx_i+ ix) = coordo( dimgeo*(numno-1)+icmp )
            end do
            !
            call VecRestoreArray(coords, xx_v, xx_i, ierr)
            ASSERT(ierr==0)
        endif
        !
        !
!           * CALCUL DES MODES A PARTIR DES COORDONNEES
        ! extract the sub-vector with corresponding dof for the submatrix of the current IS
        call VecGetSubVector(coords, is_with_bs_3, displ_coords, ierr)
        ASSERT(ierr==0)
        call MatNullSpaceCreateRigidBody(displ_coords, sp, ierr)
        ASSERT(ierr == 0)
        call MatSetNearNullSpace(myMat, sp, ierr)
        ASSERT(ierr == 0)
        ASSERT(ierr == 0)
        call MatNullSpaceDestroy(sp, ierr)
        ASSERT(ierr == 0)
        call VecDestroy(coords, ierr)
        ASSERT(ierr == 0)
        call VecDestroy(displ_coords, ierr)
        ASSERT(ierr == 0)
!
    end subroutine setNearNullSpace
!
! is_a (na entrées) est un index set inclus dans is_ab (nab entrées)
! la routive retourne is_a_in_ab contenant les indices (de 0 à nab -1)
! dans is_ab des entrées de is_a.
! Il s'agit d'un équivalent - en numérotation globale - de la routine PETSc ISEmbed
!
! Utilisation: is_u, index set repérant les ddls "u"
! est inclus dans is_up, index set repérant les ddls "u" et "p".
! On veut repérer les ddls "u" dans is_up pour construire un fieldsplit.
! Exemple : avec deux processeurs #0 et # 1
!           na = 5, nab = 9
!            | #0           | #1
! -------------------------------------------
! is_a       | 0 1 5        |  6 8
! is_ab      | 0 1 2 3 5    |  6 7 8 10
! is_a_in_ab | 0 1 4        |  5 7
! is_b_in_ab | 2 3          |  6 8
!
    subroutine is_embed_global(is_a, is_ab, is_a_in_ab, is_b_in_ab)
!
!   Dummy arguments
!
        IS, intent(in) :: is_a, is_ab
        IS, intent(out) :: is_a_in_ab
        IS, intent(out), optional :: is_b_in_ab
!   Local variables
!
        mpi_int :: rang, nbproc, mpicomm
        PetscInt :: nab_local, high_ab, low_ab, n_ab
        PetscErrorCode :: ierr
        PetscInt, parameter :: izero = 0, ione=1
        IS :: is_ind_ab, is_a_in_ab_local
        ISLocalToGlobalMapping :: mapping
!
!   Contexte parallèle (nb de processeurs, rang, communicateur MPI)
        call asmpi_info(rank=rang, size=nbproc)
        call asmpi_comm('GET', mpicomm)
!   -----------------------------------------------------
!   Construction du mapping permettant de traduire un IS
!   local (0 à n sur chaque processeur) en un IS global
!   (conforme à une numérotation globale répartie sur
!   l'ensemble des processeurs)
!   -----------------------------------------------------
!   Chaque processeur possède nab_local entrées de is_ab
        call ISGetLocalSize(is_ab, nab_local, ierr)
        ASSERT( ierr == 0 )
!   Chaque processeur possède la section d'indice global C
!   [low_ab:high_ab-1] de is_ab
        high_ab = izero
        call MPI_Scan(nab_local, high_ab, ione, MPI_INT, MPI_SUM,&
                      mpicomm, ierr)
        ASSERT(ierr == 0)
        low_ab = high_ab - nab_local
!   Vérification de cohérence
        call ISGetSize(is_ab, n_ab, ierr)
        ASSERT( ierr == 0 )
        if (rang == nbproc - 1) then
            ASSERT( high_ab == n_ab )
        endif
!   Index Set représentant les indices de is_ab, c'est à
!   dire la section [low_ab:high_ab-1] sur chaque processeur
        call ISCreateStride(mpicomm, nab_local, low_ab, ione, is_ind_ab,&
                            ierr)
        ASSERT(ierr == 0)
!   is_ind_ab est utilisé pour construire le mapping qui permettra
!   de transformer un IS local (i.e. avec des entrées de 0 à n sur chaque
!   processeur) en un  IS global
!   Construction du Mapping permettant de transformer un IS local
!   (de 0 à n sur chaque processeur) en un IS global (de O à nup_total
!   distribué sur tous les processeurs)
        call ISLocalToGlobalMappingCreateIS(is_ind_ab, mapping, ierr)
        ASSERT( ierr == 0 )
!   ----------------------------------------------------------
!   Construction de l'index set local is_a_in_ab_local
!   ----------------------------------------------------------
        call ISEmbed(is_a, is_ab, PETSC_FALSE, is_a_in_ab_local, ierr)
        ASSERT( ierr == 0 )
!   ---------------------------------------------------------------------
!   Traduction en un index set global, conforme à la répartion parallèle
!   de is_ab
!   ---------------------------------------------------------------------
        call ISLocalToGlobalMappingApplyIS(mapping, is_a_in_ab_local, is_a_in_ab, ierr)
        ASSERT( ierr == 0 )
!
        if (present( is_b_in_ab )) then
            call ISComplement(is_a_in_ab, low_ab, high_ab, is_b_in_ab, ierr)
            ASSERT( ierr == 0 )
        endif
!
        call ISDestroy(is_ind_ab, ierr)
        ASSERT( ierr == 0 )
        call ISDestroy(is_a_in_ab_local, ierr)
        ASSERT( ierr == 0 )
        call ISLocalToGlobalMappingDestroy(mapping, ierr)
        ASSERT( ierr == 0 )
!
    end subroutine is_embed_global
!
! En entrée : un vecteur de kcmp qui contient les noms des
! composantes (de la grandeur DEPL_R) que l'on cherche à identifier
! dans la matrice amat.
! blocksize est la taille de bloc (imposée pour gérer les préconditionneurs
! par blocs emboîtés)
! En sortie : l'index set (parallèle) contenant les indices dans la matrice amat
!
!
    subroutine get_is_of_field(is_of_field, nonu, amat, kcmp, blocksize)
!
! Dummy arguments
        character(len=14), intent(in) :: nonu
        Mat, intent(in) :: amat
        character(len=*), dimension(:), intent(in) :: kcmp
        IS, intent(out) :: is_of_field
        PetscInt, intent(in) :: blocksize
!
! Local variables
        aster_logical :: lmatd, lproc, lmhpc
        mpi_int :: rang, nbproc
        PetscErrorCode :: ierr
        PetscInt :: low, high, ndl
        character(len=19) :: nomat
        character(len=8) :: nomgd, nocmp
        character(len=3) :: kmatd
        integer :: ieql, ieqg, nuno, neqg
        integer :: nucmp, neql, passe, jcmp
        integer :: ieqgp
        PetscInt, dimension(:), allocatable :: idl
        integer, dimension(:), pointer :: deeq => null()
        integer, dimension(:), pointer :: nulg => null()
        integer, dimension(:), pointer :: nlgp => null()
        integer, dimension(:), pointer :: nequl => null()
        integer, dimension(:), pointer :: pddl => null()
!
        call jemarq()
!  on récupère le nombre de processeurs et le rang du processeur
!  courant
        call asmpi_info(rank=rang, size=nbproc)
!  neqg : nombre global de degrés de liberté
        call dismoi('NB_EQUA', nonu, 'NUME_DDL', repi = neqg)
        call jeveuo(nonu//'.NUME.DEEQ', 'L', vi=deeq)
!  nomgd : nom de la grandeur associée au nume_ddl
        call dismoi('NOM_GD ', nonu, 'NUME_DDL', repk = nomgd)
!  on vérifie qu'il s'agit bien de la grandeur DEPL_R
        ASSERT( nomgd == 'DEPL_R' )
!  accès au catalogue de nomgd
        call jeveuo(jexnom('&CATA.GD.NOMCMP', nomgd), 'L', jcmp)
!  Est-ce que la matrice est distribuée ?
        call dismoi('MATR_DISTRIBUEE', nonu, 'NUME_DDL', repk= kmatd)
        lmatd = ( kmatd == 'OUI' )
!  Est-ce que la matrice est distribuée dans asterxx?
        nomat = nomat_courant
        call dismoi('MATR_HPC', nomat, 'MATR_ASSE', repk=kmatd)
        lmhpc = (kmatd == 'OUI')
!  correspondance numérotation locale/ globale aster/globale PETSc
        if (lmatd) then
            call jeveuo(nonu//'.NUML.NULG', 'L', vi=nulg)
            call jeveuo(nonu//'.NUML.NLGP', 'L', vi=nlgp)
            call jeveuo(nonu//'.NUML.PDDL', 'L', vi=pddl)
            call jeveuo(nonu//'.NUML.NEQU', 'L', vi=nequl)
            neql=nequl(1)
        else if (lmhpc) then
            call jeveuo(nonu//'.NUME.NULG', 'L', vi=nulg)
            call jeveuo(nonu//'.NUME.PDDL', 'L', vi=pddl)
            call jeveuo(nonu//'.NUME.NEQU', 'L', vi=nequl)
            neql = nequl(1)
            neqg = nequl(2)
        else
            neql=neqg
        endif
! on récupère aussi les indices PETSc de la première et de la dernière+1
! ligne de la matrice PETSc
        call MatGetOwnershipRange(amat, low, high, ierr)
        ASSERT( ierr == 0 )
! On effectue deux passes :
!      passe 1 : on compte
!      passe 2 : on stocke les indices globaux PETSc dans un vecteur
        do passe = 1, 2
            ndl = 0
! Boucle sur les degrés de liberté locaux au processeur pour aster
            do ieql = 1, neql
! Indice global Aster du dl local ieql
                if (lmatd) then
                    ieqg = nulg( ieql )
                else
                    ieqg = ieql
                endif
! A quel processeur (pour PETSc) appartient le dl ?
! si la matrice est distribuée, c'est pddl qui contient l'info, sinon
! on se réfère au résultat de MatGetOwnerShipRange.
! lproc : est-ce que le processeur rang est propriétaire de ce dl ?
                if (lmatd .or. lmhpc) then
                    lproc = ( rang == pddl(ieql) )
                else
                    lproc = ( ieqg - 1 >= low ).and.(ieqg -1 <= high -1 )
                endif
                if (lproc) then
! A quelle composante de grandeur correspond ce dl ?
                    nuno=deeq(2*(ieqg-1)+1)
                    nucmp=deeq(2*(ieqg-1)+2)
! Vérification qu'il ne s'agit pas d'un Lagrange
                    ASSERT( nuno > 0 )
                    ASSERT( nucmp > 0 )
! On convertit nucmp en nocmp
                    nocmp=zk8(jcmp-1+nucmp)
! Indice global PETSc du dl local ieql
                    if (lmatd) then
                        ieqgp = nlgp ( ieql )
                    else if (lmhpc) then
! attention numerotation C, donc on ajoute "+1"
                        ieqgp = nulg ( ieql ) + 1
                    else
                        ieqgp = ieqg
                    endif
                    if (any(kcmp == nocmp )) then
                        ndl = ndl + 1
                        if (passe == 2) then
                            idl( ndl ) = ieqgp - 1
                        endif
                    endif
                endif
            enddo
            if (passe == 1) then
                if (ndl > 0) then
                    allocate ( idl( ndl ), STAT = ierr )
                endif
            endif
        enddo
!
        call ISCreateGeneral(PETSC_COMM_WORLD, ndl, idl, PETSC_COPY_VALUES, is_of_field,&
                             ierr)
        ASSERT(ierr == 0)
!
        call ISSetBlockSize(is_of_field, blocksize, ierr)
        ASSERT( ierr == 0 )
        call ISSort(is_of_field, ierr)
        ASSERT( ierr == 0 )
!
        if (allocated( idl )) then
            deallocate ( idl )
        endif
!
        call jedema()
!
    end subroutine get_is_of_field
!
!#IFDEF _HAVE_PETSC
#else
!
  public :: mfield_setup
  !
  contains
      subroutine mfield_setup(kptsc, nonu)
      integer, intent(in) :: kptsc
      character(len=14), intent(in) :: nonu
!     Local variables
      integer :: ivoid
      character(len=14) :: svoid
!     Dummy assignation to avoid warnings
      ivoid = kptsc
      svoid = nonu
    end subroutine mfield_setup
#endif
    !

end module aster_fieldsplit_module
