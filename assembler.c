#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_LINE 10000

/*This version of the assembler written by Ben and it uses a POSIX function
Using this version of the code MAY produce issues depending on your machine.
This code runs fine on MacOS, and in theory, other UNIX based systems. */

typedef enum { R4, R3, LI } InstrType;

typedef struct {
    InstrType type;
    int opcode;
} InstructionFormat;

typedef struct {
    const char* name;
    InstructionFormat format;
} InstructionEntry;

InstructionEntry instructionMap[] = {
    {"LI", {LI, 0}},

    {"MADD_LOW_INT",   {R4, 0b000}}, 
    {"MADD_HIGH_INT",  {R4, 0b001}},
    {"MSUB_LOW_INT",   {R4, 0b010}},
    {"MSUB_HIGH_INT",  {R4, 0b011}},
    {"MADD_LOW_LONG",  {R4, 0b100}},
    {"MADD_HIGH_LONG", {R4, 0b101}},
    {"MSUB_LOW_LONG",  {R4, 0b110}},
    {"MSUB_HIGH_LONG", {R4, 0b111}},

    {"NOP",  {R3, 0b00000000}}, {"SHRHI", {R3, 0b00000001}}, {"AU", {R3, 0b00000010}},
    {"CNT1W", {R3, 0b00000011}}, {"AHS", {R3, 0b00000100}}, {"NOR", {R3, 0b00000101}},
    {"BCW", {R3, 0b00000110}}, {"MAXWS", {R3, 0b00000111}}, {"MINWS", {R3, 0b00001000}},
    {"MLHU", {R3, 0b00001001}}, {"MLHCU", {R3, 0b00001010}}, {"AND", {R3, 0b00001011}},
    {"CLZH", {R3, 0b00001100}}, {"ROTW", {R3, 0b00001101}}, {"SFWU", {R3, 0b00001110}},
    {"SFHS", {R3, 0b00001111}}
};

int instructionCount = sizeof(instructionMap) / sizeof(instructionMap[0]);

void trim(char* str) {
    char* end;
    while (isspace((unsigned char)*str)) str++;
    if (*str == 0) return;
    end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char)*end)) end--;
    *(end + 1) = '\0';
}

int findInstruction(const char* name, InstructionFormat* result) {
    for (int i = 0; i < instructionCount; ++i) {
        if (strcasecmp(name, instructionMap[i].name) == 0) {
            *result = instructionMap[i].format;
            return 1;
        }
    }
    return 0;
}

int regToInt(const char* reg) {
    if (reg[0] != 'R') return -1;
    int val = atoi(&reg[1]);
    return (val >= 0 && val < 128) ? val : -1;
}

void writeBinaryString(unsigned int instruction, FILE* out) {
    char binaryString[26];
    for (int i = 24; i >= 0; --i)
        binaryString[24 - i] = (instruction & (1 << i)) ? '1' : '0';
    binaryString[25] = '\0';
    fprintf(out, "%s\n", binaryString);
}

void assembleLine(const char* line, int lineNum, FILE* outfile) {
    char temp[MAX_LINE];
    strcpy(temp, line);
    char* token = strtok(temp, " ,\n\r\t");
    if (!token) return;

    InstructionFormat format;
    if (!findInstruction(token, &format)) {
        fprintf(stderr, "Line %d: Unknown instruction '%s'\n", lineNum, token);
        return;
    }

    if (format.type == LI) {
        char* loadIdxStr = strtok(NULL, " ,\n\r\t");
        char* immStr = strtok(NULL, " ,\n\r\t");
        char* rdStr = strtok(NULL, " ,\n\r\t");

        if (!loadIdxStr || !immStr || !rdStr) {
            fprintf(stderr, "Line %d: LI requires load_index, immediate, and Rd.\n", lineNum);
            return;
        }

        int loadIdx = atoi(loadIdxStr);
        int imm = strtol(immStr, NULL, 0);
        int rd = regToInt(rdStr);

        if (loadIdx < 0 || loadIdx > 7 || imm < 0 || imm > 0xFFFF || rd == -1) {
            fprintf(stderr, "Line %d: Invalid LI operands.\n", lineNum);
            return;
        }

        unsigned int instruction = 0;
        instruction |= (loadIdx & 0x7) << 21;
        instruction |= (imm & 0xFFFF) << 5;
        instruction |= (rd & 0x1F);

        writeBinaryString(instruction, outfile);
        return;
    }

    if (format.type == R4) {
        // Format: <instr> Rd, Rs1, Rs2, Rs3
        char* regStrs[4];
        int regs[4];

        for (int i = 0; i < 4; i++) {
            regStrs[i] = strtok(NULL, " ,\n\r\t");
            if (!regStrs[i]) {
                fprintf(stderr, "Line %d: R4 instruction requires Rd, Rs1, Rs2, Rs3.\n", lineNum);
                return;
            }
            regs[i] = regToInt(regStrs[i]);
            if (regs[i] == -1) {
                fprintf(stderr, "Line %d: Invalid register '%s'\n", lineNum, regStrs[i]);
                return;
            }
        }

        int rd = regs[0];
        int rs1 = regs[1];
        int rs2 = regs[2];
        int rs3 = regs[3];

        int opcode = format.opcode;
        int bit22 = (opcode >> 2) & 1;
        int bit21 = (opcode >> 1) & 1;
        int bit20 = (opcode >> 0) & 1;

        unsigned int instruction = 0;
        instruction |= (1 << 24);
        instruction |= (0 << 23);
        instruction |= (bit22 << 22);
        instruction |= (bit21 << 21);
        instruction |= (bit20 << 20);
        instruction |= (rs3 & 0x1F) << 15;
        instruction |= (rs2 & 0x1F) << 10;
        instruction |= (rs1 & 0x1F) << 5;
        instruction |= (rd & 0x1F);

        writeBinaryString(instruction, outfile);
        return;
    }

    if (format.type == R3) {
        // Format: <instr> Rd, Rs1, Rs2
        char* regStrs[3];
        int regs[3];

        for (int i = 0; i < 3; i++) {
            regStrs[i] = strtok(NULL, " ,\n\r\t");
            if (!regStrs[i]) {
                fprintf(stderr, "Line %d: R3 requires Rd, Rs1, Rs2.\n", lineNum);
                return;
            }
            regs[i] = regToInt(regStrs[i]);
            if (regs[i] == -1) {
                fprintf(stderr, "Line %d: Invalid register '%s'\n", lineNum, regStrs[i]);
                return;
            }
        }

        int rd = regs[0];
        int rs1 = regs[1];
        int rs2 = regs[2];

        unsigned int instruction = 0;
        instruction |= (1 << 24);
        instruction |= (1 << 23);
        instruction |= (format.opcode & 0xFF) << 15;
        instruction |= (rs2 & 0x1F) << 10;
        instruction |= (rs1 & 0x1F) << 5;
        instruction |= (rd & 0x1F);

        writeBinaryString(instruction, outfile);
        return;
    }
}

int main(int argc, char* argv[]) {
    if (argc < 3) {
        fprintf(stderr, "Usage: assembler input.txt output.bin\n");
        return 1;
    }

    FILE* in = fopen(argv[1], "r");
    FILE* out = fopen(argv[2], "w");
    if (!in || !out) {
        fprintf(stderr, "Error opening input or output file.\n");
        return 1;
    }

    char line[MAX_LINE];
    int lineNum = 0;
    while (fgets(line, sizeof(line), in)) {
        lineNum++;
        trim(line);
        if (line[0] == '\0' || line[0] == ';') continue;
        assembleLine(line, lineNum, out);
    }

    fclose(in);
    fclose(out);
    printf("Binary assembly complete.\n");
    return 0;
}
